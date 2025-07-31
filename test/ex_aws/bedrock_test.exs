defmodule ExAws.BedrockTest do
  use ExUnit.Case, async: true
  import ExAws.Bedrock, only: [request: 1, request!: 1]
  alias ExAws.Bedrock
  alias ExAws.Bedrock.Titan.TextModel
  alias ExAws.Operation.JSON

  @model_id "amazon.titan-text-lite-v1"
  @prompt "Hello, LLM!"

  describe "get_custom_model/1" do
    @tag :aws
    test "unknown from AWS", %{request: get_unknown_model} do
      assert {:error, {:http_error, 400, _}} = request(get_unknown_model)
    end

    test "http get", %{request: request} do
      assert %JSON{http_method: :get} = request
    end

    test "path", %{model_id: model_id, request: request} do
      expected_path = "/custom-models/#{model_id}"
      assert %JSON{path: ^expected_path} = request
    end

    test "service", %{request: request} do
      assert %JSON{service: :bedrock} = request
    end

    setup do
      model_id = String.reverse(@model_id)
      request = Bedrock.get_custom_model(model_id)
      {:ok, [model_id: model_id, request: request]}
    end
  end

  describe "get_foundation_model/1" do
    @tag :aws
    test "from AWS", %{request: request} do
      assert %{
               "modelDetails" => %{
                 "modelId" => @model_id
               }
             } = request!(request)
    end

    test "http get", %{request: request} do
      assert %JSON{http_method: :get} = request
    end

    test "path", %{request: request} do
      assert %JSON{path: "/foundation-models/amazon.titan-text-lite-v1"} = request
    end

    test "service", %{request: request} do
      assert %JSON{service: :bedrock} = request
    end

    setup do
      request = Bedrock.get_foundation_model(@model_id)
      {:ok, [request: request]}
    end
  end

  describe "invoke_model/2 text" do
    @tag :aws
    test "against AWS" do
      inference_parameters = TextModel.build(@prompt, maxTokenCount: 32)
      request = Bedrock.invoke_model(@model_id, inference_parameters)
      assert {:ok, %{"results" => [%{"outputText" => _output} | _]}} = request(request)
    end

    @tag :aws
    test "against AWS!" do
      inference_parameters = TextModel.build(@prompt, maxTokenCount: 32)
      request = Bedrock.invoke_model(@model_id, inference_parameters)
      assert %{"results" => [%{"outputText" => _output} | _]} = request!(request)
    end

    test "content type is JSON", %{request: request} do
      assert %JSON{headers: headers} = request
      assert {_, "application/json"} = List.keyfind(headers, "Content-Type", 0)
    end

    test "http post", %{request: request} do
      assert %JSON{http_method: :post} = request
    end

    test "path", %{request: request} do
      assert %JSON{path: "/model/amazon.titan-text-lite-v1/invoke"} = request
    end

    test "service", %{request: request} do
      assert %JSON{service: :"bedrock-runtime"} = request
    end

    setup do
      request = Bedrock.invoke_model(@model_id, %{})
      {:ok, [request: request]}
    end
  end

  describe "list_foundation_models/1" do
    @tag :aws
    test "all models at AWS" do
      request = Bedrock.list_foundation_models()
      assert %{"modelSummaries" => [%{} | _]} = request!(request)
    end

    @tag :aws
    test "models provided by Amazon" do
      provider = "Amazon"
      request = Bedrock.list_foundation_models(by_provider: provider)
      assert %{"modelSummaries" => [%{"providerName" => ^provider} | _]} = request!(request)
    end

    @tag :aws
    test "text models" do
      request = Bedrock.list_foundation_models(by_output_modality: :TEXT)

      assert %{"modelSummaries" => [%{"outputModalities" => ["TEXT" | _]} | _]} =
               request!(request)
    end

    @tag :aws
    test "text models provided by Meta" do
      provider = "Meta"
      request = Bedrock.list_foundation_models(by_output_modality: :TEXT, by_provider: provider)

      assert %{
               "modelSummaries" => [
                 %{"outputModalities" => ["TEXT" | _], "providerName" => ^provider} | _
               ]
             } =
               request!(request)
    end

    @tag :aws
    test "on demand models" do
      request = Bedrock.list_foundation_models(by_output_modality: :TEXT)

      assert %{"modelSummaries" => [%{"inferenceTypesSupported" => ["ON_DEMAND" | _]} | _]} =
               request!(request)
    end

    @tag :aws
    test "allow fine tuning" do
      request = Bedrock.list_foundation_models(by_customization_type: :FINE_TUNING)

      assert %{"modelSummaries" => [%{"customizationsSupported" => ["FINE_TUNING"]} | _]} =
               request!(request)
    end

    test "by customization type" do
      request = Bedrock.list_foundation_models(by_customization_type: :FINE_TUNING)
      assert %JSON{params: %{"byCustomizationType" => :FINE_TUNING}} = request
    end

    test "by inference type" do
      request = Bedrock.list_foundation_models(by_inference_type: :ON_DEMAND)
      assert %JSON{params: %{"byInferenceType" => :ON_DEMAND}} = request
    end

    test "by output modality" do
      request = Bedrock.list_foundation_models(by_output_modality: :TEXT)
      assert %JSON{params: %{"byOutputModality" => :TEXT}} = request
    end

    test "by provider" do
      request = Bedrock.list_foundation_models(by_provider: "Amazon")
      assert %JSON{params: %{"byProvider" => "Amazon"}} = request
    end

    test "http get", %{request: request} do
      assert %JSON{http_method: :get} = request
    end

    test "path", %{request: request} do
      assert %JSON{path: "/foundation-models"} = request
    end

    test "service", %{request: request} do
      assert %JSON{service: :bedrock} = request
    end

    setup do
      request = Bedrock.list_foundation_models()
      {:ok, [request: request]}
    end
  end

  describe "converse/2" do
    test "content type is JSON", %{request: request} do
      assert %JSON{headers: headers} = request
      assert {_, "application/json"} = List.keyfind(headers, "Content-Type", 0)
    end

    test "http post", %{request: request} do
      assert %JSON{http_method: :post} = request
    end

    test "path", %{request: request} do
      assert %JSON{path: "/model/anthropic.claude-3-sonnet-20240229-v1/converse"} = request
    end

    test "service", %{request: request} do
      assert %JSON{service: :"bedrock-runtime"} = request
    end

    setup do
      model_id = "anthropic.claude-3-sonnet-20240229-v1"

      request_body = %{
        "messages" => [
          %{"role" => "user", "content" => [%{"text" => "Hello"}]}
        ]
      }

      request = Bedrock.converse(model_id, request_body)
      {:ok, [request: request, model_id: model_id]}
    end
  end

  describe "converse_stream/2" do
    test "content type is JSON", %{request: request} do
      assert %JSON{headers: headers} = request
      assert {_, "application/json"} = List.keyfind(headers, "Content-Type", 0)
    end

    test "http post", %{request: request} do
      assert %JSON{http_method: :post} = request
    end

    test "path", %{request: request} do
      assert %JSON{path: "/model/anthropic.claude-3-sonnet-20240229-v1/converse-stream"} = request
    end

    test "service", %{request: request} do
      assert %JSON{service: :"bedrock-runtime"} = request
    end

    test "has stream_builder", %{request: request} do
      assert %JSON{stream_builder: stream_builder} = request
      assert is_function(stream_builder)
    end

    setup do
      model_id = "anthropic.claude-3-sonnet-20240229-v1"

      request_body = %{
        "messages" => [
          %{"role" => "user", "content" => [%{"text" => "Hello"}]}
        ]
      }

      request = Bedrock.converse_stream(model_id, request_body)
      {:ok, [request: request, model_id: model_id]}
    end
  end
end
