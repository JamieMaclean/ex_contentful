defmodule Content.RichText.Parser do
  alias Content.Field.RichText.Node.Paragraph
  alias Content.Field.RichText.Node.Text
  alias Content.Field.RichText.Node.Blockquote

  def search_adapter([first], rest, adapter) do
    case adapter.html_block([first]) do
      :no_match -> {default_html(first, adapter), rest}
      match -> {match, rest}
    end
  end

  def search_adapter([last | rest] = current_block, remainder, adapter) do
    case adapter.html_block(current_block) do
      :no_match -> search_adapter(rest, [last | remainder], adapter)
      match -> {match, remainder}
    end
  end

  def default_html(node, adapter)

  def default_html(%Paragraph{} = node, adapter) do
    content = adapter.parse_content(node.content)
    {"p", [], content}
  end

  def default_html(%Blockquote{} = node, adapter) do
    content = adapter.parse_content(node.content)
    {"blockquote", [], content}
  end

  def default_html(%Text{marks: [], value: value}, _), do: value

  def default_html(%Text{marks: marks, value: value}, _),
    do: wrap_with_marks(marks, value)

  defp wrap_with_marks([], value), do: value

  defp wrap_with_marks([%{type: mark} | rest], value) do
    {mark_to_tag(mark), [], wrap_with_marks(rest, value)}
  end

  defp mark_to_tag("bold"), do: "b"
  defp mark_to_tag("italic"), do: "em"
  defp mark_to_tag("underline"), do: "u"
  defp mark_to_tag("code"), do: "code"
end
