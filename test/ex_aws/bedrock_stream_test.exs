defmodule ExAws.Bedrock.InvokeModelStreamTest do
  use ExUnit.Case, async: true
  import ExAws.Bedrock, only: [stream!: 1]
  alias ExAws.Bedrock
  alias ExAws.Bedrock.Titan.TextModel
  alias ExAws.Operation.JSON

  describe "invoke_model_with_response_stream/2 text" do
    @tag :aws
    test "against AWS", %{request: request} do
      response =
        request
        |> stream!()
        |> Enum.to_list()

      assert [{:chunk, %{"completionReason" => "FINISH", "index" => 0}} | _] = response
      assert {:chunk, %{"completionReason" => "FINISH"}} = List.last(response)
    end

    test "content type is JSON", %{request: request} do
      assert %JSON{headers: headers} = request
      assert {_, "application/json"} = List.keyfind(headers, "Content-Type", 0)
    end

    test "http post", %{request: request} do
      assert %{http_method: :post} = request
    end

    test "content type JSON", %{request: request} do
      assert %JSON{headers: [{"Content-Type", "application/json"}]} = request
    end

    test "path", %{model_id: model_id, request: request} do
      expected_path = "/model/#{model_id}/invoke-with-response-stream"
      assert %JSON{path: ^expected_path} = request
    end

    setup do
      prompt = ~s[Write a short and friendly way to say hello to José Valim. 10 words max.]

      model_id = "amazon.titan-tg1-large"
      inference_parameters = TextModel.build(prompt, max_token_count: 400, temperature: 0.6)
      request = Bedrock.invoke_model_with_response_stream(model_id, inference_parameters)
      {:ok, [model_id: model_id, request: request]}
    end
  end

  describe "converse_stream/2 text" do
    @tag :aws
    test "against AWS", %{request: request} do
      response =
        request
        |> stream!()
        |> Enum.to_list()

      assert [{:chunk, _} | _] = response
    end

    test "content type is JSON", %{request: request} do
      assert %JSON{headers: headers} = request
      assert {_, "application/json"} = List.keyfind(headers, "Content-Type", 0)
    end

    test "http post", %{request: request} do
      assert %{http_method: :post} = request
    end

    test "path", %{model_id: model_id, request: request} do
      expected_path = "/model/#{model_id}/converse-stream"
      assert %JSON{path: ^expected_path} = request
    end

    test "service", %{request: request} do
      assert %JSON{service: :"bedrock-runtime"} = request
    end

    test "has stream_builder", %{request: request} do
      assert %{stream_builder: stream_builder} = request
      assert is_function(stream_builder)
    end

    setup do
      model_id = "us.anthropic.claude-3-7-sonnet-20250219-v1:0"
      anthropic_version = "bedrock-2023-05-31"
      prompt = "Write a short story about a dog"

      request_body = %{
        "messages" => [
          %{
            "role" => "user",
            "content" => [
              %{"text" => prompt, "type" => "text"}
            ]
          }
        ],
        "max_tokens" => 500,
        "anthropic_version" => anthropic_version
      }

      request = Bedrock.converse_stream(model_id, request_body)
      {:ok, [model_id: model_id, request: request]}
    end
  end
end
