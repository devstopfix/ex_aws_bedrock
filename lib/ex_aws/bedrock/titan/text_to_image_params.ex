defmodule ExAws.Bedrock.Titan.TextToImageParams do
  @moduledoc """
  Text to image generation.

  * text (Required) – A text prompt to generate the image.
  * negativeText (Optional) – A text prompt to define what not to include in the image.
  """

  @type t :: %__MODULE__{
          text: String.t(),
          negativeText: String.t() | nil
        }

  defstruct text: "", negativeText: nil

  defimpl Jason.Encoder, for: __MODULE__ do
    def encode(value, opts) do
      drop_nils = for {k, v} <- Map.from_struct(value), v != nil, into: %{}, do: {k, v}
      Jason.Encode.map(drop_nils, opts)
    end
  end
end
