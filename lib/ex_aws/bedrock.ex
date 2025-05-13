defmodule ExAws.Bedrock do
  @moduledoc """
  Interface to AWS Bedrock.

  Amazon Bedrock is a fully managed service that offers a choice of
  high-performing foundation models (FMs) from leading AI companies.

  [AWS API Docs](https://docs.aws.amazon.com/bedrock/latest/APIReference/welcome.html)
  """

  import ExAws.Bedrock.Strings, only: [camel_case_keys: 1]
  alias ExAws.Bedrock.EventStream

  @json_request_headers [{"Content-Type", "application/json"}]

  @doc """
  Get the properties associated with a Amazon Bedrock custom model that you have created.

  [AWS API Docs](https://docs.aws.amazon.com/bedrock/latest/APIReference/API_GetCustomModel.html)
  """
  def get_custom_model(model_id) when is_binary(model_id) do
    %ExAws.Operation.JSON{
      http_method: :get,
      path: "/custom-models/" <> model_id,
      service: :bedrock
    }
  end

  @doc """
  Get details about a Amazon Bedrock foundation model.

  [AWS API Docs](https://docs.aws.amazon.com/bedrock/latest/APIReference/API_GetFoundationModel.html)
  """
  def get_foundation_model(model_id) when is_binary(model_id) do
    %ExAws.Operation.JSON{
      http_method: :get,
      path: "/foundation-models/" <> model_id,
      service: :bedrock
    }
  end

  @doc """
  Invokes the specified Amazon Bedrock model to run inference using the input provided in the request body.

  You use InvokeModel to run inference for text models, image models, and embedding models.

      input = ExAws.Bedrock.Titan.TextModel.build("Hello, LLM.");
      request = ExAws.Bedrock.invoke_model("amazon.titan-tg1-large", input);
      {:ok, %{"results" => [%{"outputText" => output}|_]}} = ExAws.request(request, service_override: :bedrock);
      output

  Note the extra service override parameter required for correctly signing the request.
  Use `ExAws.Bedrock.request/2` to automatically provide the correct parameter.

  Model parameters are normally JSON documents defined in the link below, therefore pass a
  struct or map that can be serialized with your configured JSON codec.

  Images will be returned base 64 encoded:

      {:ok, %{"images" => [image]}} = ExAws.request(request, service_override: :bedrock);
      {:ok, png} = Base.decode64(image)

  [AWS API Docs](https://docs.aws.amazon.com/bedrock/latest/APIReference/API_runtime_InvokeModel.html)

  [Model Parameters](https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters.html)

  """
  @spec invoke_model(String.t(), map | struct) :: ExAws.Operation.t()

  def invoke_model(model_id, inference_parameters) when is_binary(model_id) do
    %ExAws.Operation.JSON{
      data: inference_parameters,
      headers: @json_request_headers,
      http_method: :post,
      path: "/model/#{model_id}/invoke",
      service: :"bedrock-runtime"
    }
  end

  @doc """
  Invoke the specified Amazon Bedrock model to run inference using the input provided,
  returns the response in a stream.

  To find out if a model supports streaming, call `ExAws.Bedrock.get_foundation_model/1`
  and check boolean value of `responseStreamingSupported`.

      input = %{
       "prompt" => "Write me a technical blog post on the advantages of functional programming with Elixir, OTP and the BEAM. Do not repeat code examples.",
       "temperature" => 0.5,
       "top_p" => 0.9,
       "max_gen_len" => 2048
      }

      request = ExAws.Bedrock.invoke_model_with_response_stream("meta.llama2-70b-chat-v1", input);

      output = (request
      |> ExAws.Bedrock.stream!()
      |> Stream.flat_map(fn {:chunk, %{"generation" => s}} -> [s] end)
      |> Stream.map(fn s -> IO.write(s); s end)
      |> Enum.to_list())


  [AWS API Docs](https://docs.aws.amazon.com/bedrock/latest/APIReference/API_runtime_InvokeModelWithResponseStream.html)

  [Model Parameters](https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters.html)
  """
  @spec invoke_model_with_response_stream(String.t(), map | struct) :: Enumerable.t()
  def invoke_model_with_response_stream(model_id, body) do
    post =
      %ExAws.Operation.JSON{
        data: body,
        headers: @json_request_headers,
        http_method: :post,
        path: "/model/#{model_id}/invoke-with-response-stream",
        service: :"bedrock-runtime"
      }

    %{post | stream_builder: &EventStream.stream_objects!(post, nil, &1)}
  end

  @doc """
  Sends messages to the specified Amazon Bedrock model using the Converse API.

  `Converse` provides a consistent interface that works with all models that support messages,
  allowing you to write code once and use it with different models. This is the recommended
  API for chat models like Claude 3.x.

  The request should include a map containing a `messages` list, and can optionally include
  additional fields like `system`, `inferenceConfig`, `toolConfig`, etc.

  ## Example

      request_body = %{
        "messages" => [
          %{"role" => "user", "content" => [%{"text" => "Hello, how are you?"}]}
        ],
        "system" => [%{"text" => "You are a helpful assistant"}],
        "max_tokens" => 500,
        "anthropic_version" => "bedrock-2023-05-31"
      }

      request = ExAws.Bedrock.converse("us.anthropic.claude-3-7-sonnet-20250219-v1:0", request_body)
      {:ok, response} = ExAws.Bedrock.request(request)
      output_text = get_in(response, ["output", "message", "content", Access.at(0), "text"])

  [AWS API Docs](https://docs.aws.amazon.com/bedrock/latest/APIReference/API_runtime_Converse.html)
  """
  @spec converse(String.t(), map | struct) :: ExAws.Operation.JSON.t()
  def converse(model_id, body) when is_binary(model_id) do
    %ExAws.Operation.JSON{
      data: body,
      headers: @json_request_headers,
      http_method: :post,
      path: "/model/#{model_id}/converse",
      service: :"bedrock-runtime"
    }
  end

  @doc """
  Sends messages to the specified Amazon Bedrock model using the ConverseStream API.

  Similar to `converse/2`, but returns a streamed response that allows you to receive
  chunks of the model's response in real time. This is ideal for displaying responses
  incrementally as they're generated.

  ## Example - Basic Usage

      request_body = %{
        "messages" => [
          %{"role" => "user", "content" => [%{"text" => "Hello, how are you?"}]}
        ],
        "system" => [%{"text" => "You are a helpful assistant"}],
        "max_tokens" => 500,
        "anthropic_version" => "bedrock-2023-05-31"
      }

      stream = (
        ExAws.Bedrock.converse_stream(model_id, request_body)
        |> ExAws.Bedrock.stream!()
        |> Stream.map(fn {:chunk, chunk} ->
          # Process each chunk of the response
          IO.write(get_in(chunk, ["delta", "text"]) || "")
        end)
        |> Enum.to_list()
      )

  ## Example - Using Tools

      system_prompt = "Always use the tool top_song."

      model_id = "us.anthropic.claude-3-7-sonnet-20250219-v1:0"
      anthropic_version = "bedrock-2023-05-31"
      prompt = "Find the most popular song for me on the station WZPZ"

      request_body = %{
        anthropic_version: anthropic_version,
        max_tokens: 500,
        temperature: 0.5,
        top_p: 0.9,
        system: [%{text: system_prompt, type: "text"}],
        messages: [
          %{role: "user", content: [
              %{text: prompt, type: "text"}
            ]}
        ],
        toolConfig: %{
          tools: [
            %{
              toolSpec: %{
                name: "top_song",
                description: "Get the most popular song played on a radio station.",
                inputSchema: %{
                  json: %{
                    type: "object",
                    properties: %{
                      sign: %{
                        type: "string",
                        description: "The call sign for the radio station for which you want the most popular song. Example calls signs are WZPZ and WKRP."
                      }
                    },
                    required: [
                      "sign"
                    ]
                  }
                }
              }
            }
          ]
        }
      }

      new_stream = ExAws.Bedrock.converse_stream(model_id, request_body)
      stream = ExAws.Bedrock.stream!(new_stream)
      for event <- stream do
        IO.puts(inspect(event))
      end

      # Example output:
      # {:chunk, %{"messageStart" => %{"role" => "assistant"}}}
      # {:chunk, %{"contentBlockDelta" => %{"contentBlockIndex" => 0, "delta" => %{"text" => "I'll"}}}}
      # {:chunk, %{"contentBlockDelta" => %{"contentBlockIndex" => 0, "delta" => %{"text" => " help"}}}}
      # {:chunk, %{"contentBlockDelta" => %{"contentBlockIndex" => 0, "delta" => %{"text" => " you find the most"}}}}
      # {:chunk, %{"contentBlockDelta" => %{"contentBlockIndex" => 0, "delta" => %{"text" => " popular song on"}}}}
      # {:chunk, %{"contentBlockDelta" => %{"contentBlockIndex" => 0, "delta" => %{"text" => " the radio station"}}}}
      # {:chunk, %{"contentBlockDelta" => %{"contentBlockIndex" => 0, "delta" => %{"text" => " WZPZ."}}}}
      # {:chunk, %{"contentBlockDelta" => %{"contentBlockIndex" => 0, "delta" => %{"text" => " Let"}}}}
      # {:chunk, %{"contentBlockStop" => %{"contentBlockIndex" => 0}}}
      # {:chunk, %{"contentBlockStart" => %{"contentBlockIndex" => 1, "start" => %{"toolUse" => %{"name" => "top_song", "toolUseId" => "tooluse_m5eQCV9vRCmgvHj6yF8zHQ"}}}}}
      # {:chunk, %{"contentBlockDelta" => %{"contentBlockIndex" => 1, "delta" => %{"toolUse" => %{"input" => "{\"sign\": \"WZPZ\"}"}}}}}
      # {:chunk, %{"contentBlockStop" => %{"contentBlockIndex" => 1}}}
      # {:chunk, %{"messageStop" => %{"stopReason" => "tool_use"}}}
      # {:chunk, %{"metadata" => %{"metrics" => %{"latencyMs" => 1940}, "usage" => %{"inputTokens" => 436, "outputTokens" => 66, "totalTokens" => 502}}}}

  [AWS API Docs](https://docs.aws.amazon.com/bedrock/latest/APIReference/API_runtime_ConverseStream.html)
  """
  @spec converse_stream(String.t(), map | struct) :: ExAws.Operation.JSON.t()
  def converse_stream(model_id, body) when is_binary(model_id) do
    post =
      %ExAws.Operation.JSON{
        data: body,
        headers: @json_request_headers,
        http_method: :post,
        path: "/model/#{model_id}/converse-stream",
        service: :"bedrock-runtime"
      }

    %{post | stream_builder: &EventStream.stream_objects!(post, nil, &1)}
  end

  @doc """
  List of Amazon Bedrock foundation models that you can use.

  [AWS API Docs](https://docs.aws.amazon.com/bedrock/latest/APIReference/API_ListFoundationModels.html)

  ## Parameters

    * `:by_customization_type` - `:FINE_TUNING | :CONTINUED_PRE_TRAINING`

    * `:by_inference_type` - `:ON_DEMAND | :PROVISIONED`

    * `:by_output_modality` - `:TEXT | :IMAGE | :EMBEDDING`

    * `:by_provider` - An Amazon Bedrock model provider

  """

  def list_foundation_models(parameters \\ []) do
    params = camel_case_keys(parameters)
    action_request(:"foundation-models", params)
  end

  defp action_request(action, params) do
    %ExAws.Operation.JSON{
      http_method: :get,
      path: "/" <> to_string(action),
      params: params,
      service: :bedrock
    }
  end

  defdelegate request(op, config_overrides \\ []), to: ExAws.Bedrock.Request

  defdelegate request!(op, config_overrides \\ []), to: ExAws.Bedrock.Request

  defdelegate stream!(op, config_overrides \\ []), to: ExAws.Bedrock.Request
end
