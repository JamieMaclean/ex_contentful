defmodule Content.RichText.Adapter do
  defmacro __using__(_) do
    quote do
      import Content.RichText.Adapter
      alias Content.Field.RichText.Node.Paragraph
      alias Content.Field.RichText.Node.Text
      alias Content.Field.RichText.Node.Blockquote

      def parse_content([]) do
        []
      end

      def parse_content(content) do
        case search_adapter(Enum.reverse(content), []) do
          {html, []} -> [html]
          {html, rest} when is_list(html) -> html ++ parse_content(rest)
          {html, rest} -> [html] ++ parse_content(rest)
        end
      end

      def search_adapter([first], rest) do
        case html_block([first]) do
          :no_match -> {default_html(first), rest}
          match -> {match, rest}
        end
      end

      def search_adapter([last | rest] = current_block, remainder) do
        case html_block(current_block) do
          :no_match -> search_adapter(rest, [last | remainder])
          match -> {match, remainder}
        end
      end

      def default_html(node)

      def default_html(%Paragraph{} = node) do
        content = parse_content(node.content)
        {"p", [], content}
      end

      def default_html(%Blockquote{} = node) do
        content = parse_content(node.content)
        {"blockquote", [], content}
      end

      def default_html(%Text{marks: [], value: value}), do: value

      def default_html(%Text{marks: marks, value: value}, data),
        do: {wrap_with_marks(marks, value), data}

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

      @before_compile Content.RichText.Adapter
    end
  end

  defmacro __before_compile__(_) do
    quote do
      def html_block(_html_block) do
        :no_match
      end
    end
  end

  defmacro html_block(html_block, do: block) when is_list(html_block) do
    quote do
      def html_block(unquote(Enum.reverse(html_block))) do
        unquote(block)
      end
    end
  end
end
