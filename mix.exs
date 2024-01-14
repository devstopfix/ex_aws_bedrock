defmodule ExAws.Bedrock.MixProject do
  use Mix.Project

  @version "2.5.1"
  @service "bedrock"
  @url "https://github.com/devstopfix/ex_aws_#{@service}"
  @name "ExAws.Bedrock"

  def project do
    [
      app: :ex_aws_bedrock,
      deps: deps(),
      description:
        "The easiest way to build and scale generative AI applications with foundation models",
      docs: [main: @name, source_ref: "v#{@version}", source_url: @url],
      elixir: "~> 1.14",
      package: package(),
      start_permanent: Mix.env() == :prod,
      version: @version
    ]
  end

  defp package do
    [
      description: "#{@name} service package",
      files: ["lib", "mix.exs", "README.md"],
      licenses: ["MIT"],
      links: %{
        Bedrock: "https://aws.amazon.com/bedrock/",
        ExAws: "https://hex.pm/packages/ex_aws",
        Docs: "https://hexdocs.pm/ex_aws_bedrock/#{@version}",
        GitHub: @url
      },
      maintainers: ["J Every"]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:ex_aws, ">= 2.5.1"},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:hackney, ">= 0.0.0", only: [:dev, :test]},
      {:jason, ">= 0.1.0", only: [:dev, :test]}
    ]
  end
end
