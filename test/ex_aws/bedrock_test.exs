defmodule ExAws.BedrockTest do
  use ExUnit.Case
  doctest ExAws.Bedrock

  test "greets the world" do
    assert ExAws.Bedrock.hello() == :world
  end
end
