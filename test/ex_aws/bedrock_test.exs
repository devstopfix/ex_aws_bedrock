defmodule ExAws.BedrockTest do
  use ExUnit.Case
  import ExAws.Bedrock, only: [request: 1, request!: 1]
  alias ExAws.Bedrock
  alias ExAws.Bedrock.Titan.TextModel
  alias ExAws.Operation.JSON

  @model_id "amazon.titan-text-lite-v1"
  @prompt "Hello, LLM!"

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

    test "body as map" do
      request = Bedrock.invoke_model(@model_id, %{})
      assert %JSON{data: "{}"} = request
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
end
