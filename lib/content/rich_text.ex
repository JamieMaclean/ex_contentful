defmodule Content.RichText do
  @moduledoc false

  @callback to_html(node :: struct(), data :: any()) :: {struct(), any()}
  @callback get_attributes(node :: struct()) :: list(tuple())

  defmacro __before_compile__(_) do
    quote do
      alias Content.Field.RichText.Node.{Document, Paragraph, Text, Blockquote}

      def to_html(%Document{} = node, nil) do
        {content, data} = parse_content(node.content, [], nil)
        Floki.raw_html(content)
      end

      def to_html(%Paragraph{} = node, data) do
        {content, data} = parse_content(node.content, [], data)
        {{"p", get_attributes(node), content}, data}
      end

      def to_html(%Blockquote{} = node, data) do
        {content, data} = parse_content(node.content, [], data)
        {{"blockquote", get_attributes(node), content}, data}
      end

      def to_html(%Text{marks: [], value: value}, data), do: {value, data}

      def to_html(%Text{marks: marks, value: value}, data),
        do: {wrap_with_marks(marks, value), data}

      def parse_content([[]], html, data) do
        {Enum.reverse(html), data}
      end

      def parse_content([last], html, data) do
        parse_content([last | [[]]], html, data)
      end

      def parse_content([current_node | rest], html, data) do
        {node_html, data} = to_html(current_node, data)
        parse_content(rest, [node_html | html], data)
      end

      def get_attributes(_node) do
        []
      end

      defp wrap_with_marks([], value), do: value

      defp wrap_with_marks([%{type: mark} | rest], value) do
        {open, close} = mark_to_tag(mark)
        wrapped_value = open <> value <> close
        wrap_with_marks(rest, wrapped_value)
      end

      defp mark_to_tag("bold"), do: {"<b>", "</b>"}
      defp mark_to_tag("italic"), do: {"<em>", "</em>"}
      defp mark_to_tag("underline"), do: {"<u>", "</u>"}
      defp mark_to_tag("code"), do: {"<code>", "</code>"}
    end
  end

  defmacro __using__(_) do
    quote do
      @behaviour Content.RichText

      @before_compile Content.RichText
    end
  end
end
