defmodule ExAws.Bedrock.Titan.ImageModel do
  @moduledoc """
  Inference parameters for Amazon Titan image generation models.

  [AWS API Docs](https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters-titan-image.html)
  """

  alias ExAws.Bedrock.Titan.ImageGenerationConfig
  alias ExAws.Bedrock.Titan.TextToImageParams

  @derive Jason.Encoder
  defstruct taskType: "TEXT_IMAGE",
            textToImageParams: %TextToImageParams{},
            imageGenerationConfig: %ImageGenerationConfig{}
end
