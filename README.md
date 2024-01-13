# ExAws.Bedrock

> The easiest way to build and scale generative AI applications with foundation models
> -- https://aws.amazon.com/bedrock/


Service module for [Elixir AWS](https://github.com/ex-aws/ex_aws).

***NOTE*** this is a work in progress as the operations are uploaded over the next few days
and requires a minimum `ex_aws` version of 2.5.1.

[![ci](https://github.com/devstopfix/ex_aws_bedrock/actions/workflows/ci.yml/badge.svg)](https://github.com/devstopfix/ex_aws_bedrock/actions/workflows/ci.yml)

## Installation

The package can be installed by adding `:ex_aws_bedrock` to your list of dependencies in `mix.exs`
along with `:ex_aws`, `:jason` JSON codec, and your preferred HTTP client

```elixir
def deps do
  [
    {:ex_aws, ">= 2.5.1"},
    {:ex_aws_bedrock, "~> 0.5"},
    {:hackney, "~> 1.9"},
    {:jason, "~> 1.1"},
    {:poison, "~> 3.0"}
  ]
end
```

While `ex_aws` allows you to choose JSON codec the input to the AWS models are JSON and this library
chooses to accept maps and structs that implement the [Jason Encoder protocol](jason).

## License

The MIT License (MIT).

[json]: https://hexdocs.pm/jason/Jason.Encoder.html