defmodule ExAws.Bedrock do
  @moduledoc """
  Interface to AWS Bedrock.

  Amazon Bedrock is a fully managed service that offers a choice of
  high-performing foundation models (FMs) from leading AI companies.

  [AWS API Docs](https://docs.aws.amazon.com/bedrock/latest/APIReference/welcome.html)
  """

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
end
