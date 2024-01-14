defmodule ExAws.Bedrock.Titan.ImageGenerationConfig do
  @moduledoc """
  Inference parameters for Amazon Titan image generation models.

  [AWS API Docs](https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters-titan-image.html)
  """

  @type quality :: :standard | :premium

  @type t :: %__MODULE__{
          cfgScale: float(),
          height: pos_integer(),
          numberOfImages: pos_integer(),
          quality: quality(),
          seed: integer(),
          width: pos_integer()
        }

  @derive Jason.Encoder
  defstruct numberOfImages: 1,
            quality: :standard,
            height: 1024,
            width: 1024,
            cfgScale: 8.0,
            seed: 0
end
