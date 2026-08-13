defmodule ExAws.Bedrock.Nova.TextModel do
  @moduledoc """
  Top-level request payload structure for Amazon Nova models on Bedrock.
  """

  alias ExAws.Bedrock.Nova.{InferenceConfig, Message, ToolConfig}

  defstruct [
    :messages,
    :system,
    :inferenceConfig,
    :toolConfig
  ]

  @type t :: %__MODULE__{
          messages: list(Message.t()),
          system: list(%{text: String.t()}) | nil,
          inferenceConfig: InferenceConfig.t() | nil,
          toolConfig: ToolConfig.t() | nil
        }

  @doc """
  Build a `TextModel` struct.

  ## Options
    * `:system` - String system prompt or list of system prompt maps.
    * `:inference_config` - Keyword list or `%InferenceConfig{}`.
    * `:tool_config` - Keyword list or `%ToolConfig{}`.
  """
  def build(messages, opts \\ []) when is_list(messages) do
    system =
      case Keyword.get(opts, :system) do
        nil -> nil
        prompt when is_binary(prompt) -> [%{text: prompt}]
        list when is_list(list) -> list
      end

    inference_config =
      case Keyword.get(opts, :inference_config) do
        %InferenceConfig{} = config -> config
        opts when is_list(opts) -> InferenceConfig.build(opts)
        _ -> nil
      end

    tool_config = Keyword.get(opts, :tool_config)

    %__MODULE__{
      messages: messages,
      system: system,
      inferenceConfig: inference_config,
      toolConfig: tool_config
    }
  end
end

defimpl Jason.Encoder, for: ExAws.Bedrock.Nova.TextModel do
  def encode(struct, opts) do
    struct
    |> Map.from_struct()
    |> Enum.reject(fn {_k, v} -> is_nil(v) end)
    |> Map.new()
    |> Jason.Encode.map(opts)
  end
end