defmodule ExAws.Bedrock.Nova.ToolSpec do
  @moduledoc """
  Defines an individual tool schema for tool use/function calling.
  """

  defstruct [:name, :description, :inputSchema]

  @type t :: %__MODULE__{
          name: String.t(),
          description: String.t() | nil,
          inputSchema: %{json: map()}
        }

  def build(name, description, json_schema) do
    %{
      toolSpec: %__MODULE__{
        name: name,
        description: description,
        inputSchema: %{json: json_schema}
      }
    }
  end
end

defimpl Jason.Encoder, for: ExAws.Bedrock.Nova.ToolSpec do
  def encode(struct, opts) do
    struct
    |> Map.from_struct()
    |> Enum.reject(fn {_k, v} -> is_nil(v) end)
    |> Map.new()
    |> Jason.Encode.map(opts)
  end
end
