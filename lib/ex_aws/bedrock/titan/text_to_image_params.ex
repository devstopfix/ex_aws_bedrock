defmodule ExAws.Bedrock.Titan.TextToImageParams do
  @moduledoc false

  defstruct text: "", negativeText: nil

  defimpl Jason.Encoder, for: __MODULE__ do
    def encode(value, opts) do
      value
      |> Map.from_struct()
      |> Map.filter(fn {_, v} -> v != nil end)
      |> Jason.Encode.map(opts)
    end
  end
end
