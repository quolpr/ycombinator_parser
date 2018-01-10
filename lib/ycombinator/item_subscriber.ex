defmodule Ycombinator.ItemSubscriber do
  @moduledoc """
  Put to the console Item from ycombinator
  """

  @behaviour Ycombinator.RecentNotifier.Subscriber

  def new_item(nil), do: nil

  def new_item(%Ycombinator.Api.Item{text: text, type: "comment"}) do
    print_item("Comment", text)
  end

  def new_item(%Ycombinator.Api.Item{url: url, type: "story"}) do
    print_item("Story", url)
  end

  def new_item(%Ycombinator.Api.Item{title: title, text: text}) do
    print_item(title, text)
  end

  defp print_item(title, text) do
    IO.puts(title)
    IO.puts("============================")
    IO.puts(HtmlSanitizeEx.strip_tags(text))
    IO.puts("\n")
  end
end
