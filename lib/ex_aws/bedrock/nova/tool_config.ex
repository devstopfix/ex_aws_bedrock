defmodule ExAws.Bedrock.Nova.ToolConfig do
  @moduledoc """
  Tool specifications and tool choice settings.
  """

  defstruct [:tools, :toolChoice]

  @type tool_choice :: %{auto: %{}} | %{any: %{}} | %{tool: %{name: String.t()}}
  @type t :: %__MODULE__{
          tools: list(map()),
          toolChoice: tool_choice() | nil
        }

  def build(tools, tool_choice \\ :auto) do
    %__MODULE__{
      tools: tools,
      toolChoice: format_tool_choice(tool_choice)
    }
  end

  defp format_tool_choice(:auto), do: %{auto: %{}}
  defp format_tool_choice(:any), do: %{any: %{}}
  defp format_tool_choice({:tool, name}) when is_binary(name), do: %{tool: %{name: name}}
  defp format_tool_choice(map) when is_map(map), do: map
end

defimpl Jason.Encoder, for: ExAws.Bedrock.Nova.ToolConfig do
  def encode(struct, opts) do
    struct
    |> Map.from_struct()
    |> Enum.reject(fn {_k, v} -> is_nil(v) end)
    |> Map.new()
    |> Jason.Encode.map(opts)
  end
end