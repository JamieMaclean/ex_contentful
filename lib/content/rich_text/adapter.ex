defmodule Content.RichText.Adapter do
  # coveralls-ignore-start

  defmacro __using__(_) do
    quote do
      import Content.RichText.Adapter
      alias Content.RichText.Parser
      alias Content.Field.RichText.Node.Document
      alias Content.Field.RichText.Node.Paragraph
      alias Content.Field.RichText.Node.Text
      alias Content.Field.RichText.Node.Blockquote
      alias Content.Field.RichText.Node.Hr

      def to_html(%Document{content: content}) do
        parse_content(content)
        |> Floki.raw_html()
      end

      def to_html(content) when is_list(content) do
        parse_content(content)
        |> Floki.raw_html()
      end

      def to_html(content) do
        parse_content([content])
        |> Floki.raw_html()
      end

      def parse_content([]) do
        []
      end

      def parse_content(content) do
        case Parser.search_adapter(Enum.reverse(content), [], __MODULE__) do
          {html, []} -> [html]
          {html, rest} when is_list(html) -> html ++ parse_content(rest)
          {html, rest} -> [html] ++ parse_content(rest)
        end
      end

      @before_compile Content.RichText.Adapter
    end
  end

  defmacro __before_compile__(_) do
    quote do
      def html_block(_) do
        :no_match
      end
    end
  end

  defmacro html_block(rich_text_block, do: block) when is_list(rich_text_block) do
    reversed_block = Enum.reverse(rich_text_block)

    quote do
      def html_block(unquote(reversed_block)) do
        unquote(block)
      end
    end
  end

  # coveralls-ignore-end
end
