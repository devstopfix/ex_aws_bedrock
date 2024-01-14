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

      assert [{:chunk, %{"completionReason" => nil, "index" => 0}} | _] = response
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
      prompt = ~s[Write me an article in the style of serious technical about
      the Elixir programming language and how it's combination of the Erlang BEAM
      and functional programming is a revolution in creating reliable software]

      model_id = "amazon.titan-tg1-large"
      inference_parameters = TextModel.build(prompt, max_token_count: 4000, temperature: 0.6)
      request = Bedrock.invoke_model_with_response_stream(model_id, inference_parameters)
      {:ok, [model_id: model_id, request: request]}
    end
  end
end
