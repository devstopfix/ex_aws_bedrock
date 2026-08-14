defmodule ExAws.Bedrock.Nova.Message do
  @moduledoc """
  Encapsulates user and assistant turns in the conversation.
  """

  alias ExAws.Bedrock.Nova.Content

  defstruct [:role, :content]

  @type role :: :user | :assistant
  @type t :: %__MODULE__{
          role: String.t(),
          content: list(map())
        }

  @doc "Constructs a user turn with text or multimodal content items."
  def user(content) when is_binary(content), do: build("user", [Content.text(content)])
  def user(content) when is_list(content), do: build("user", content)

  @doc "Constructs an assistant turn (useful for prompt pre-filling)."
  def assistant(content) when is_binary(content), do: build("assistant", [Content.text(content)])
  def assistant(content) when is_list(content), do: build("assistant", content)

  def build(role, content) when role in ["user", "assistant", :user, :assistant] do
    %__MODULE__{
      role: to_string(role),
      content: content
    }
  end
end

defimpl Jason.Encoder, for: ExAws.Bedrock.Nova.Message do
  def encode(struct, opts) do
    struct
    |> Map.from_struct()
    |> Enum.reject(fn {_k, v} -> is_nil(v) end)
    |> Map.new()
    |> Jason.Encode.map(opts)
  end
end
