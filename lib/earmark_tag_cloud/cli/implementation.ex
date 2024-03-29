defmodule EarmarkTagCloud.Cli.Implementation do
  use EarmarkTagCloud.Types

  @type output_tuple :: {:stderr, binary()} | {:stdio, binary()}
  @typep parse_result :: :help | :version | output_tuple() | binary()

  @annotation "%tc:"

  @spec run(list(binary)) :: output_tuple()
  def run(argv) do
    argv
    |> _parse_args()
    |> _process()
  end

  @args """
  usage:

     earmark_tag_cloud --help
     earmark_tag_cloud --version
     earmark_tag_cloud [ options... <file> ]

  convert file from Markdown to HTML.using Earmark and allowing for EarmarkTagCloud annotations

     where options can be any of:

     none so far
  """

  @spec _parse_args(binaries()) :: parse_result()
  defp _parse_args(argv) do
    switches = [
      ]
    aliases = [
      h: :help,
      v: :version
    ]

    case OptionParser.parse(argv, switches: switches, aliases: aliases) do
      { [ {:help, true} ], _, _ } -> :help
      { [ {:version, true} ], _, _ } -> :version
      { _options, [ file ],  _ }  -> file
      { _options, [ ],           _ }  -> {:stderr, "need a file argument"}
    end
  end

  @spec _process(parse_result()) :: output_tuple()
  defp _process(what)
  defp _process({_, _}=output), do: output
  defp _process(:help), do: {:stdio, @args}
  defp _process(:version), do: {:stdio, EarmarkTagCloud.version}
  defp _process(file), do: _process_file(file)


  @spec _process_file(binary()) :: output_tuple()
  defp _process_file(file) do
    cond do
      String.ends_with?(file, ".eex") -> {:stdio, "EEx templates coming soon"}
      true                            -> _process_markdown(file)
    end
  end

  @spec _process_markdown(binary()) :: output_tuple()
  defp _process_markdown(file) do
    try do
      {:stdio, _transform_markdown(file)}
    rescue
      e in File.Error -> {:stderr, Exception.message(e)}
    end
  end

  @spec _transform_markdown(binary()) :: binary()
  defp _transform_markdown(file) do
    file
      |> File.stream!([:utf8], :line)
      |> Enum.to_list
      |> Earmark.as_ast!(annotations: @annotation)
      |> EarmarkTagCloud.make_tag_clouds
      |> Earmark.transform
  end
end
