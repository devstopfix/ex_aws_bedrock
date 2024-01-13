defmodule ExAws.Bedrock.Request do
  @moduledoc false

  defdelegate request(op, config_overrides \\ []), to: ExAws

  defdelegate request!(op, config_overrides \\ []), to: ExAws
end
