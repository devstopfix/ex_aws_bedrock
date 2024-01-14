defmodule ExAws.Bedrock.InvokeModelImageTest do
  use ExUnit.Case, async: true
  import ExAws.Bedrock, only: [request!: 1]
  alias ExAws.Bedrock
  alias ExAws.Bedrock.Titan.{ImageGenerationConfig, ImageModel, TextToImageParams}

  describe "invoke_model/2 image" do
    @tag :aws
    test "against AWS returns PNG", %{
      height: height,
      model_id: model_id,
      seed: seed,
      text_to_image_params: text_to_image_params,
      width: width
    } do
      image_model = %ImageModel{
        textToImageParams: text_to_image_params,
        imageGenerationConfig: %ImageGenerationConfig{
          height: height,
          seed: seed,
          width: width
        }
      }

      req = Bedrock.invoke_model(model_id, image_model)
      assert %{"images" => [image]} = request!(req)
      assert {:ok, png} = Base.decode64(image)
      assert_png(png, %{height: height, width: width})
    end

    setup [:setup_seed, :setup_image_model, :setup_image_size, :setup_text_to_image_params]
  end

  describe "list_foundation_models/1" do
    @tag :aws
    test "image models provided by Amazon" do
      provider = "Amazon"
      request = Bedrock.list_foundation_models(by_provider: provider, by_output_modality: :IMAGE)

      assert %{
               "modelSummaries" => [
                 %{
                   "providerName" => ^provider,
                   "outputModalities" => ["IMAGE"]
                 }
                 | _
               ]
             } = request!(request)
    end
  end

  defp setup_seed(%{seed: _} = context), do: context

  defp setup_seed(_) do
    seed = ExUnit.configuration()[:seed]
    [seed: seed]
  end

  defp setup_image_model(_) do
    [model_id: "amazon.titan-image-generator-v1"]
  end

  defp setup_image_size(_) do
    [
      height: 512,
      width: 512
    ]
  end

  defp setup_text_to_image_params(_) do
    [
      text_to_image_params: %TextToImageParams{
        text: "Draw me a logo for the Elixir programming language shaped like a potion"
      }
    ]
  end

  defp assert_png(image, %{height: height, width: width}) do
    assert <<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, _length::size(32), "IHDR",
             ^width::size(32), ^height::size(32), _::binary>> = image
  end
end
