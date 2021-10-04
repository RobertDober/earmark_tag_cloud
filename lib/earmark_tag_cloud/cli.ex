defmodule EarmarkTagCloud.Cli do
  @usage """
  usage:

      earmark_tag_cloud --help
      earmark_tag_cloud --version
      earmark_tag_cloud [ options... <file> ]

  convert file from Markdown to HTML.using Earmark and allowing for EarmarkTagCloud annotations

  cond do

      file ends with .eex -> treat it as an EEx template

      true                -> treat file as plain markdown

  """

  @moduledoc @usage

  def main(argv) do
    argv
    |> EarmarkTagCloud.Cli.Implementation.run()
    |> output()
  end

  defp output({device, string}) do
    IO.puts(device, string)
    if device == :stderr, do: exit(1)
  end
end
