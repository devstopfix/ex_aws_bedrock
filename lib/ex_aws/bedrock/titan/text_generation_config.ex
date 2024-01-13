defmodule ExAws.Bedrock.Titan.TextGenerationConfig do
  @moduledoc """
  Inference parameters for Amazon Titan text models.

  [AWS API Docs](https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters-titan-text.html)
  """

  @derive Jason.Encoder
  defstruct maxTokenCount: 512, stopSequences: [], temperature: 0.0, topP: 1.0

  @doc """
  Build struct from Elixir style keyword list.

  Parameters:
  * max_token_count
  * stop_sequences
  * temperature
  * top_p
  """
  def build(parameters \\ []), do: struct(__MODULE__, Enum.flat_map(parameters, &parameter/1))

  defp parameter({:max_token_count, i}) when is_integer(i), do: [maxTokenCount: i]

  defp parameter({:stop_sequences, xs = [x | _]}) when is_list(xs) and is_binary(x),
    do: [stopSequences: xs]

  defp parameter({:temperature, n}) when is_number(n), do: [temperature: n]
  defp parameter({:top_p, n}) when is_number(n), do: [topP: n]
  defp parameter(_), do: []
end
