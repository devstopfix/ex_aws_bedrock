defmodule ExAws.Bedrock.MixProject do
  use Mix.Project

  @version "0.0.24"
  @service "bedrock"
  @url "https://github.com/devstopfix/ex_aws_#{@service}"
  @name "ExAws.Bedrock"

  def project do
    [
      app: :ex_aws_bedrock,
      version: @version,
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: [main: @name, source_ref: "v#{@version}", source_url: @url],
      package: package()
    ]
  end

  defp package do
    [
      description: "#{@name} service package",
      files: ["lib", "config", "mix.exs", "README*"],
      maintainers: ["J Every"],
      licenses: ["MIT"],
      links: %{GitHub: @url}
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:hackney, ">= 0.0.0", only: [:dev, :test]},
      {:jason, ">= 0.0.0", only: [:dev, :test]},
      {:sweet_xml, ">= 0.0.0", optional: true},
      ex_aws()
    ]
  end

  defp ex_aws() do
    case System.get_env("AWS") do
      "LOCAL" -> {:ex_aws, path: "../ex_aws"}
      _ -> {:ex_aws, "~> 2.0"}
    end
  end
end
