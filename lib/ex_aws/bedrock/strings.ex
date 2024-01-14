defmodule ExAws.Bedrock.Strings do
  @moduledoc false

  @doc """
  Convert an atom or string from snake_case to camelCase.

  We cannot use `ExAws.Utils.camelize/1` as it outputs PascalCase.
  """
  @spec camel_case(atom | String.t()) :: String.t()
  def camel_case(s) when is_atom(s) or is_binary(s) do
    [x | xs] = s |> to_string() |> String.split("_")
    for s <- xs, into: x, do: String.capitalize(s)
  end

  @doc "Convert keys of map or keyword list into map with camelCased keys"
  @spec camel_case_keys(list | map) :: %{optional(String.t()) => term}
  def camel_case_keys(kvs) do
    for {k, v} <- kvs, into: %{}, do: {camel_case(k), v}
  end
end
