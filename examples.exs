defmodule ExAws.Bedrock.Examples do
  alias ExAws.Bedrock
  alias ExAws.Bedrock.Titan.TextModel

  def prompts, do: "PROMPTS" |> File.stream!(line_or_bytes: :line) |> Stream.map(&String.trim/1)

  @doc "Amazon Titan text models (on-demand)"
  def titan_text_models do
    request =
      Bedrock.list_foundation_models(
        by_provider: "Amazon",
        by_output_modality: :TEXT,
        by_inference_type: :ON_DEMAND
      )

    %{"modelSummaries" => model_summaries} = Bedrock.request!(request)
    for %{"modelId" => model_id} <- model_summaries, do: {model_id, &titan_invocation/2}
  end

  def titan_invocation(prompt, temperature \\ 0.0),
    do: TextModel.build(prompt, max_token_count: 80, temperature: temperature)

  @doc "Meta text models (on-demand)"
  def meta_text_models do
    request =
      Bedrock.list_foundation_models(
        by_provider: "Meta",
        by_output_modality: :TEXT,
        by_inference_type: :ON_DEMAND
      )

    %{"modelSummaries" => model_summaries} = Bedrock.request!(request)
    for %{"modelId" => model_id} <- model_summaries, do: {model_id, &meta_invocation/2}
  end

  def meta_invocation(prompt, temperature \\ 0.0),
    do: %{
      "prompt" => prompt,
      "temperature" => temperature,
      "top_p" => 0.9,
      "max_gen_len" => 80
    }

  def temperatures, do: [0.0, 0.8]

  def tasks(prompts, models) do
    for prompt <- prompts,
        {model, invocation} <- models,
        temperature <- temperatures(),
        do: {prompt, model, temperature, invocation}
  end

  @doc "Call AWS API"
  def invoke(request, opts \\ [{:pool, :aws}]) do
    http_req = fn -> Bedrock.request!(request, http_opts: opts) end

    case :timer.tc(http_req, :millisecond) do
      {elapsed, %{"results" => [%{"outputText" => output} | _]}} ->
        {elapsed, output}

      {elapsed, %{"generation" => output}} ->
        {elapsed, output}
    end
  end

  def run do
    :ok =
      :hackney_pool.start_pool(:aws, [
        {:connect_timeout, 2_000},
        {:recv_timeout, 8_000},
        {:keepalive, true}
      ])

    models = titan_text_models() ++ meta_text_models()
    tasks = tasks(prompts(), models)

    for {prompt, model, temperature, invocation} <- tasks do
      IO.puts("Asking #{model} \"#{prompt}\" with temperature=#{temperature}")

      request =
        Bedrock.invoke_model(
          model,
          invocation.(prompt, temperature)
        )

      {elapsed, output} = invoke(request)
      IO.puts("\t#{output}\n")
      IO.puts("(#{elapsed} ms) ----------\n\n")
    end
  end
end

ExAws.Bedrock.Examples.run()
