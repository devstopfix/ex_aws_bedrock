defmodule ExAws.Bedrock.Titan.TextModel do
  @moduledoc """
  Inference parameters for Amazon Titan text models.

  [AWS API Docs](https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters-titan-text.html)
  """

  alias ExAws.Bedrock.Titan.TextGenerationConfig

  @derive Jason.Encoder
  defstruct inputText: "Hello, LLM.", textGenerationConfig: %TextGenerationConfig{}

  @doc "Build struct from Elixir style keyword list"
  def build(input_text, parameters \\ []) when is_binary(input_text) do
    config = TextGenerationConfig.build(parameters)

    %__MODULE__{
      inputText: input_text,
      textGenerationConfig: config
    }
  end
end
