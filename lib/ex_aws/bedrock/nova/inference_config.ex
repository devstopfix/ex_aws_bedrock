defmodule ExAws.Bedrock.Nova.InferenceConfig do
  @moduledoc """
  Inference options for Nova text models.
  """

  alias ExAws.Bedrock.Nova.ReasoningConfig

  defstruct [
    :maxTokens,
    :temperature,
    :topP,
    :topK,
    :stopSequences,
    :reasoningConfig
  ]

  @type t :: %__MODULE__{
          maxTokens: pos_integer() | nil,
          temperature: float() | nil,
          topP: float() | nil,
          topK: non_neg_integer() | nil,
          stopSequences: list(String.t()) | nil,
          reasoningConfig: ReasoningConfig.t() | nil
        }

  def build(opts \\ []) when is_list(opts) do
    reasoning =
      case Keyword.get(opts, :reasoning_config) do
        %ReasoningConfig{} = config -> config
        opts when is_list(opts) -> ReasoningConfig.build(opts)
        _ -> nil
      end

    %__MODULE__{
      maxTokens: Keyword.get(opts, :max_tokens),
      temperature: Keyword.get(opts, :temperature),
      topP: Keyword.get(opts, :top_p),
      topK: Keyword.get(opts, :top_k),
      stopSequences: Keyword.get(opts, :stop_sequences),
      reasoningConfig: reasoning
    }
  end
end

defimpl Jason.Encoder, for: ExAws.Bedrock.Nova.InferenceConfig do
  def encode(struct, opts) do
    struct
    |> Map.from_struct()
    |> Enum.reject(fn {_k, v} -> is_nil(v) end)
    |> Map.new()
    |> Jason.Encode.map(opts)
  end
end