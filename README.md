# ExAws.Bedrock

> The easiest way to build and scale generative AI applications with foundation models
> -- https://aws.amazon.com/bedrock/


Service module for [Elixir AWS](https://github.com/ex-aws/ex_aws).

***NOTE*** this is a work in progress and awaiting [PR 1023](https://github.com/ex-aws/ex_aws/pull/1023).

[![ci](https://github.com/devstopfix/ex_aws_bedrock/actions/workflows/ci.yml/badge.svg)](https://github.com/devstopfix/ex_aws_bedrock/actions/workflows/ci.yml)

## Installation

The package can be installed by adding `:ex_aws_bedrock` to your list of dependencies in `mix.exs`
along with `:ex_aws` and your preferred JSON codec / HTTP client

```elixir
def deps do
  [
    {:ex_aws, "~> 2.0"},
    {:ex_aws_bedrock, "~> 0.1"},
    {:poison, "~> 3.0"},
    {:hackney, "~> 1.9"}
  ]
end
```

## License

The MIT License (MIT).