defmodule ExAws.Bedrock.Titan.TextModelTest do
  use ExUnit.Case

  alias ExAws.Bedrock.Titan.{TextGenerationConfig, TextModel}

  describe "build/1" do
    test "with prompt" do
      assert %TextModel{inputText: "input"} = TextModel.build("input")
    end
  end

  describe "build/2" do
    test "maxTokenCount", %{prompt: prompt} do
      %TextModel{textGenerationConfig: config} = TextModel.build(prompt, max_token_count: 50)
      assert %TextGenerationConfig{maxTokenCount: 50} = config
    end

    test "temperature", %{prompt: prompt} do
      %TextModel{textGenerationConfig: config} = TextModel.build(prompt, temperature: 0.8)
      assert %TextGenerationConfig{temperature: 0.8} = config
    end

    test "stopSequences", %{prompt: prompt} do
      %TextModel{textGenerationConfig: config} = TextModel.build(prompt, stop_sequences: ["4."])
      assert %TextGenerationConfig{stopSequences: ["4."]} = config
    end

    test "topP", %{prompt: prompt} do
      %TextModel{textGenerationConfig: config} = TextModel.build(prompt, top_p: 0.8)
      assert %TextGenerationConfig{topP: 0.8} = config
    end
  end

  setup_all do
    d =
      DateTime.utc_now()
      |> DateTime.add(-20 * 365, :day)
      |> Calendar.strftime("%A %B %d, %Y")

    prompt = "Write a Wikipedia article about historic events on the day of #{d}"
    {:ok, [prompt: prompt]}
  end
end
