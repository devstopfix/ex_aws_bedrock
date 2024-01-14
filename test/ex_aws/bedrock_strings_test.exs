defmodule ExAws.BedrockStringsTest do
  use ExUnit.Case
  import ExAws.Bedrock.Strings, only: [camel_case_keys: 1]

  describe "camel_case_keys/1" do
    test "map" do
      assert %{
               "foo" => 1,
               "fooBar" => 2,
               "fooBarBaz" => 3
             } == camel_case_keys(%{:foo => 1, "foo_bar" => 2, :foo_bar_baz => 3})
    end

    test "key words" do
      assert %{
               "foo" => 1,
               "fooBar" => 2,
               "fooBarBaz" => 3
             } == camel_case_keys(foo: 1, foo_bar: 2, foo_bar_baz: 3)
    end
  end
end
