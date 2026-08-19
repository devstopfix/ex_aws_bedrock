defmodule ExAws.Bedrock.HttpError do
  @moduledoc """
  Raised by `ExAws.Bedrock.EventStream.stream_objects!/3` when Bedrock answers
  a non-200 status, carrying the HTTP status and the `x-amzn-ErrorType` header
  so callers can classify (throttling vs capacity vs permanent) instead of
  parsing a lossy message string.
  """
  defexception [:status, :error_type, message: "Bedrock HTTP error"]
end
