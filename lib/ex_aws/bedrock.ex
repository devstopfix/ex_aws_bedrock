defmodule ExAws.Bedrock do
  @moduledoc """
  Interface to AWS Bedrock.

  Amazon Bedrock is a fully managed service that offers a choice of
  high-performing foundation models (FMs) from leading AI companies.

  [AWS API Docs](https://docs.aws.amazon.com/bedrock/latest/APIReference/welcome.html)
  """

  @json_request_headers [{"Content-Type", "application/json"}]

  @doc """
  Get details about a Amazon Bedrock foundation model.

  [AWS API Docs](https://docs.aws.amazon.com/bedrock/latest/APIReference/API_GetFoundationModel.html)
  """
  def get_foundation_model(model_id) when is_binary(model_id) do
    %ExAws.Operation.JSON{
      http_method: :get,
      path: "/foundation-models/" <> model_id,
      service: :bedrock
    }
  end

  @doc """
  Invokes the specified Amazon Bedrock model to run inference using the input provided in the request body.

  You use InvokeModel to run inference for text models, image models, and embedding models.

      input = ExAws.Bedrock.Titan.TextModel.build("Hello, LLM.");
      request = ExAws.Bedrock.invoke_model("amazon.titan-tg1-large", input);
      {:ok, %{"results" => [%{"outputText" => output}|_]}} = ExAws.request(request, service_override: :bedrock);
      output

  Note the extra service override parameter required for correctly signing the request.
  Use `ExAws.Bedrock.request/2` to automatically provide the correct parameter.

  Model parameters are normally JSON documents defined in the link below, therefore pass a
  struct or map that can be serialized with `Jason.encode/1`.

  [AWS API Docs](https://docs.aws.amazon.com/bedrock/latest/APIReference/API_runtime_InvokeModel.html)

  [Model Parameters](https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters.html)

  """
  @spec invoke_model(String.t(), Jason.Encoder.t()) :: ExAws.Operation.t()

  def invoke_model(model_id, inference_parameters) when is_binary(model_id) do
    %ExAws.Operation.JSON{
      data: inference_parameters,
      headers: @json_request_headers,
      http_method: :post,
      path: "/model/#{model_id}/invoke",
      service: :"bedrock-runtime"
    }
  end

  defdelegate request(op, config_overrides \\ []), to: ExAws.Bedrock.Request

  defdelegate request!(op, config_overrides \\ []), to: ExAws.Bedrock.Request
end
