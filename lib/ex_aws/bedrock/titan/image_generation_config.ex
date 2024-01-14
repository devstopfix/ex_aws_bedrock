defmodule ExAws.Bedrock.Titan.ImageGenerationConfig do
  @moduledoc """
  Inference parameters for Amazon Titan image generation models.

  [AWS API Docs](https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters-titan-image.html)
  """

  @derive Jason.Encoder
  defstruct numberOfImages: 1,
            quality: "standard",
            height: 1024,
            width: 1024,
            cfgScale: 8.0,
            seed: 0
end
