<!--
DO NOT EDIT THIS FILE
It has been generated from the template `README.md.eex` by Extractly (https://github.com/RobertDober/extractly.git)
and any changes you make in this file will most likely be lost
-->

All doctests in this README have been extracted from the code by [Extractly](https://github.com/RobertDober/extractly)
and are therefore tested

## EarmarkTagCloud


[![CI](https://github.com/RobertDober/earmark_tag_cloud/actions/workflows/ci.yml/badge.svg)](https://github.com/RobertDober/earmark_tag_cloud/actions/workflows/ci.yml)
[![Coverage Status](https://coveralls.io/repos/github/RobertDober/earmark_tag_cloud/badge.svg?branch=master)](https://coveralls.io/github/RobertDober/earmark_tag_cloud?branch=master)
[![Hex.pm](https://img.shields.io/hexpm/v/earmark_tag_cloud.svg)](https://hex.pm/packages/earmark_tag_cloud)
[![Hex.pm](https://img.shields.io/hexpm/dw/earmark_tag_cloud.svg)](https://hex.pm/packages/earmark_tag_cloud)
[![Hex.pm](https://img.shields.io/hexpm/dt/earmark_tag_cloud.svg)](https://hex.pm/packages/earmark_tag_cloud)

- Make Tag Clouds from a simple DSL

    e.g.
    ```
    12 16 100 # translates to style="color: #000000; font-size: 16pt; font-weight: 100;"
    #ffdd00 3em bb # style="color: #ffdd00; font-size: 3em; font-weight: 800;"

    ```

- Elixir Tools to create Tag clouds

  - `EarmarkTagCloud.Compiler.dsl_to_attributes`

```elixir
      iex(1)> EarmarkTagCloud.Compiler.dsl_to_attributes("12 16 100")
      [{"style", "color: #000000; font-size: 16pt; font-weight: 100;"}]
```

- Independent Library Functions

- Gamma correction for scaled colors

- Earmark Integration (needs v1.4.16-pre2 or greater)

  The most general way to integrate with Earmark is with `make_tag_clouds`

```elixir
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
```

  We can render to html directly with `render_html`, which is a shortcut for the above

```elixir
    iex(3)> markdown = [
    ...(3)> "Elixir %tc: 12 20 800", "",
    ...(3)> "Erlang %tc: 10/red 2em", "",
    ...(3)> "Phoenix %tc: 8/sandybrown" ]
    ...(3)> render_html(markdown)
    "<span style=\"color: #000000; font-size: 20pt; font-weight: 800;\">\nElixir </span>\n<span style=\"color: #ff7171; font-size: 2em;\">\nErlang </span>\n<span style=\"color: #ed6d00;\">\nPhoenix </span>\n"
```


  Or just transform the AST

```elixir
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
```

  which is a shortcut for this

```elixir
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
```

  Of course not annotated blocks are not effected

```elixir
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
```

  And different annotations can be used, but than `make_tag_clouds` becomes a _NOP_

```elixir
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
```


## EarmarkTagCloud.version/0

A convenience method to access this library's version

```elixir
    iex(8)> {:ok, _} = Version.parse(version())
```


### EarmarkTagCloud.Cli

usage:

    earmark_tag_cloud --help
    earmark_tag_cloud --version
    earmark_tag_cloud [ options... <file> ]

convert file from Markdown to HTML.using Earmark and allowing for EarmarkTagCloud annotations

cond do

    file ends with .eex -> treat it as an EEx template

    true                -> treat file as plain markdown



### EarmarkTagCloud.version/0

A convenience method to access this library's version

```elixir
    iex(8)> {:ok, _} = Version.parse(version())
```


### EarmarkTagCloud.Compiler

Compiles tag cloud specifications of the form
`color font_size font_weight color` to corresponding HTML attributes

#### EarmarkTagCloud.Compiler.dsl_to_attributes/1

Implements the compilation

### Gray Scale

```elixir
    iex(1)> dsl_to_attributes("10 12 100")
    [{"style", "color: #717171; font-size: 12pt; font-weight: 100;"}]
```

### Scale on Predefined Colors

All 140 color names defined by the CSS standard are supported.
The complete list can be found [here](https://en.wikipedia.org/wiki/Web_colors#Extended_colors)

```elixir
    iex(2)> dsl_to_attributes("8/fuchsia 3em 800")
    [{"style", "color: #ff9bff; font-size: 3em; font-weight: 800;"}]
```

### Just use your own color

```elixir
    iex(3)> dsl_to_attributes("#cafe00")
    [{"style", "color: #cafe00;"}]
```



## EarmarkTagCloud.EarmarkAst

An Earmark AST processor which will change annotated tag cloud paragraphs into spans with the necessary attributes

Needs Earmark version 1.4.16-pre2 or later

E.g.

```elixir
    iex(1)> markdown = [
    ...(1)> "Elixir %tc: 10/blue 18 800", "",
    ...(1)> "Ruby %tc: 4/red 10 100"]
    ...(1)> render_html(markdown)
    "<span style=\"color: #7171ff; font-size: 18pt; font-weight: 800;\">\nElixir </span>\n<span style=\"color: #ffd4d4; font-size: 10pt; font-weight: 100;\">\nRuby </span>\n"
```



## Author

Copyright © 2021 Robert Dober, robert.dober@gmail.com,

# LICENSE

Same as Elixir, which is Apache License v2.0. Please refer to [LICENSE](LICENSE) for details.

<!-- SPDX-License-Identifier: Apache-2.0 -->
