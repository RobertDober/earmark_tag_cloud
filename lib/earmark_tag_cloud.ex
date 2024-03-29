defmodule EarmarkTagCloud do
  @moduledoc ~S"""

  [![CI](https://github.com/RobertDober/earmark_tag_cloud/actions/workflows/ci.yml/badge.svg)](https://github.com/RobertDober/earmark_tag_cloud/actions/workflows/ci.yml)
  [![Coverage Status](https://coveralls.io/repos/github/RobertDober/earmark_tag_cloud/badge.svg?branch=master)](https://coveralls.io/github/RobertDober/earmark_tag_cloud?branch=master)
  [![Hex.pm](https://img.shields.io/hexpm/v/earmark_tag_cloud.svg)](https://hex.pm/packages/earmark_tag_cloud)
  [![Hex.pm](https://img.shields.io/hexpm/dw/earmark_tag_cloud.svg)](https://hex.pm/packages/earmark_tag_cloud)
  [![Hex.pm](https://img.shields.io/hexpm/dt/earmark_tag_cloud.svg)](https://hex.pm/packages/earmark_tag_cloud)

  - Make Tag Clouds from a simple DSL added as annotations to paragraphs

      e.g.
      ```
      12 16 100 # translates to style="color: #000000; font-size: 16pt; font-weight: 100;"
      #ffdd00 3em bb # style="color: #ffdd00; font-size: 3em; font-weight: 800;"

      ```

  - Elixir Tools to create Tag clouds

        iex(1)> dsl_to_attributes("12 16 100")
        [{"style", "color: #000000; font-size: 16pt; font-weight: 100;"}]

  - Earmark Integration (needs v1.4.16-pre2 or greater)

    The most general way to integrate with Earmark is with `make_tag_clouds`

      iex(2)> markdown = [
      ...(2)> "Elixir %tc: 12 20 800", "",
      ...(2)> "Erlang %tc: 10/red 2em", "",
      ...(2)> "Phoenix %tc: 8/sandybrown" ]
      ...(2)> render_html(markdown)
      ...(2)> markdown
      ...(2)> |> Earmark.as_ast!(annotations: "%tc:", inner_html: true)
      ...(2)> |> make_tag_clouds
      ...(2)> |> Earmark.transform
      "<span style=\"color: #000000; font-size: 20pt; font-weight: 800;\">\nElixir </span>\n<span style=\"color: #ff7171; font-size: 2em;\">\nErlang </span>\n<span style=\"color: #ed6d00;\">\nPhoenix </span>\n"

    We can render to html directly with `render_html`, which is a shortcut for the above

      iex(3)> markdown = [
      ...(3)> "Elixir %tc: 12 20 800", "",
      ...(3)> "Erlang %tc: 10/red 2em", "",
      ...(3)> "Phoenix %tc: 8/sandybrown" ]
      ...(3)> render_html(markdown)
      "<span style=\"color: #000000; font-size: 20pt; font-weight: 800;\">\nElixir </span>\n<span style=\"color: #ff7171; font-size: 2em;\">\nErlang </span>\n<span style=\"color: #ed6d00;\">\nPhoenix </span>\n"


    Or just transform the AST

      iex(4)> markdown = [
      ...(4)> "Elixir %tc: 12 20 800", "",
      ...(4)> "Erlang %tc: 10/red 2em", "",
      ...(4)> "Phoenix %tc: 8/sandybrown" ]
      ...(4)> render_ast(markdown)
      [
        {"span", [{"style", "color: #000000; font-size: 20pt; font-weight: 800;"}], ["Elixir "], %{annotation: "%tc: 12 20 800"}},
        {"span", [{"style", "color: #ff7171; font-size: 2em;"}], ["Erlang "], %{annotation: "%tc: 10/red 2em"}},
        {"span", [{"style", "color: #ed6d00;"}], ["Phoenix "], %{annotation: "%tc: 8/sandybrown"}}
      ]

    which is a shortcut for this

      iex(5)> markdown = [
      ...(5)> "Elixir %tc: 12 20 800", "",
      ...(5)> "Erlang %tc: 10/red 2em", "",
      ...(5)> "Phoenix %tc: 8/sandybrown" ]
      ...(5)> markdown
      ...(5)> |> Earmark.as_ast!(annotations: "%tc:", inner_html: true)
      ...(5)> |> make_tag_clouds
      [
        {"span", [{"style", "color: #000000; font-size: 20pt; font-weight: 800;"}], ["Elixir "], %{annotation: "%tc: 12 20 800"}},
        {"span", [{"style", "color: #ff7171; font-size: 2em;"}], ["Erlang "], %{annotation: "%tc: 10/red 2em"}},
        {"span", [{"style", "color: #ed6d00;"}], ["Phoenix "], %{annotation: "%tc: 8/sandybrown"}}
      ]

    Of course not annotated blocks are not effected

      iex(6)> markdown = [
      ...(6)> "Elixir %tc: 12 20 800", "",
      ...(6)> "Erlang", "",
      ...(6)> "Phoenix %tc: 8/sandybrown" ]
      ...(6)> render_ast(markdown)
      [
        {"span", [{"style", "color: #000000; font-size: 20pt; font-weight: 800;"}], ["Elixir "], %{annotation: "%tc: 12 20 800"}},
        {"p", [], ["Erlang"], %{}},
        {"span", [{"style", "color: #ed6d00;"}], ["Phoenix "], %{annotation: "%tc: 8/sandybrown"}}
      ]

    And different annotations can be used, but than `make_tag_clouds` becomes a _NOP_

      iex(7)> markdown = [
      ...(7)> "Elixir %%%: 12 20 800", "",
      ...(7)> "Erlang %%%: 10/red 2em", "",
      ...(7)> "Phoenix %%%: 8/sandybrown" ]
      ...(7)> markdown
      ...(7)> |> Earmark.as_ast!(annotations: "%%%:", inner_html: true)
      ...(7)> |> make_tag_clouds
      [
        {"p", [], ["Elixir "], %{annotation: "%%%: 12 20 800"}},
        {"p", [], ["Erlang "], %{annotation: "%%%: 10/red 2em"}},
        {"p", [], ["Phoenix "], %{annotation: "%%%: 8/sandybrown"}}
      ]

  """


  defdelegate dsl_to_attributes(description), to: TagCloud.Compiler, as: :ast_style

  defdelegate make_tag_clouds(ast, options \\ [annotation: "%tc:"]), to: EarmarkTagCloud.EarmarkAst

  defdelegate render_ast(input), to: EarmarkTagCloud.EarmarkAst

  defdelegate render_html(input), to: EarmarkTagCloud.EarmarkAst

  @doc """
  A convenience method to access this library's version

      iex(8)> {:ok, _} = Version.parse(version())
  """
  @spec version :: binary()
  def version do
    :application.ensure_started(:earmark_tag_cloud)
    with {:ok, version} = :application.get_key(:earmark_tag_cloud, :vsn), do: to_string(version)
  end
end
#  SPDX-License-Identifier: Apache-2.0
