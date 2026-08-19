defmodule ExAws.Bedrock.EventStreamErrorTest do
  use ExUnit.Case, async: true

  alias ExAws.Bedrock.EventStream
  alias ExAws.Bedrock.HttpError

  describe "build_http_error/3" do
    test "extracts x-amzn-errortype case-insensitively and strips the URI suffix" do
      headers = [
        {"X-Amzn-ErrorType", "ServiceUnavailableException:http://internal/"},
        {"Content-Type", "application/json"}
      ]

      body = ~s({"message":"Too many connections, please wait before trying again."})
      err = EventStream.build_http_error(503, headers, body)

      assert %HttpError{status: 503, error_type: "ServiceUnavailableException"} = err
      assert err.message =~ "503"
      assert err.message =~ "Too many connections"
    end

    test "strips a namespace# prefix" do
      headers = [{"x-amzn-errortype", "com.amazon#ThrottlingException"}]

      assert %HttpError{status: 429, error_type: "ThrottlingException"} =
               EventStream.build_http_error(429, headers, "")
    end

    test "missing header leaves error_type nil" do
      assert %HttpError{status: 500, error_type: nil} =
               EventStream.build_http_error(500, [], "boom")
    end

    test "truncates huge bodies" do
      err = EventStream.build_http_error(500, [], String.duplicate("x", 10_000))
      assert byte_size(err.message) <= 2_100
    end
  end

  describe "read_error_response/2" do
    test "drains pre-delivered hackney messages and raises the structured error" do
      ref = make_ref()

      send(
        self(),
        {:hackney_response, ref,
         {:headers, [{"x-amzn-errortype", "ServiceUnavailableException:http://x/"}]}}
      )

      send(self(), {:hackney_response, ref, "Too many connections"})
      send(self(), {:hackney_response, ref, :done})

      err = assert_raise HttpError, fn -> EventStream.read_error_response(ref, 503) end

      assert err.status == 503
      assert err.error_type == "ServiceUnavailableException"
      assert err.message =~ "Too many connections"
    end

    test "raises with empty body when nothing was delivered" do
      ref = make_ref()
      send(self(), {:hackney_response, ref, :done})

      err = assert_raise HttpError, fn -> EventStream.read_error_response(ref, 502) end
      assert err.status == 502
      assert err.error_type == nil
    end
  end
end
