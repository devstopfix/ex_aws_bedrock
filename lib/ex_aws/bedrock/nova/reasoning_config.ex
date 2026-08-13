defmodule ExAws.Bedrock.Nova.ReasoningConfig do
  @moduledoc """
  Reasoning configuration parameters for Nova reasoning models.
  """

  defstruct [:type, :maxReasoningEffort]

  @type type :: String.t()
  @type max_effort :: String.t()
  @type t :: %__MODULE__{
          type: type() | nil,
          maxReasoningEffort: max_effort() | nil
        }

  def build(opts) when is_list(opts) do
    %__MODULE__{
      type: Keyword.get(opts, :type, "disabled"),
      maxReasoningEffort: Keyword.get(opts, :max_reasoning_effort)
    }
  end
end

defimpl Jason.Encoder, for: ExAws.Bedrock.Nova.ReasoningConfig do
  def encode(struct, opts) do
    struct
    |> Map.from_struct()
    |> Enum.reject(fn {_k, v} -> is_nil(v) end)
    |> Map.new()
    |> Jason.Encode.map(opts)
  end
end