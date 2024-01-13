defmodule ExAws.BedrockTest do
  use ExUnit.Case
  alias ExAws.Bedrock
  alias ExAws.Operation.JSON

  @model_id "amazon.titan-text-lite-v1"

  describe "get_foundation_model/1" do
    @tag :aws
    test "from AWS", %{request: request} do
      assert %{
               "modelDetails" => %{
                 "modelId" => @model_id
               }
             } = ExAws.request!(request)
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
end
