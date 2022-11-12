defmodule ExContentful.RichText.Adapter do
  # coveralls-ignore-start

  defmacro __using__(_) do
    quote do
      import ExContentful.RichText.Adapter
      alias ExContentful.RichText.Highlighter
      alias ExContentful.RichText.Parser
      alias ExContentful.RichText.Transformer
      alias ExContentful.Field.RichText.Node.Document
      alias ExContentful.Field.RichText.Node.Paragraph
      alias ExContentful.Field.RichText.Node.Text
      alias ExContentful.Field.RichText.Node.Blockquote
      alias ExContentful.Field.RichText.Node.Hr
      alias ExContentful.Field.RichText.Node.OrderedList
      alias ExContentful.Field.RichText.Node.ListItem

      alias ExContentful.Field.RichText.Node.{
        Heading1,
        Heading2,
        Heading3,
        Heading4,
        Heading5,
        Heading6
      }

      def to_html(%Document{} = node) do
        %Document{content: content} = Transformer.transform(node)

        parse_content(content)
        |> Transformer.transform()
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
        |> List.flatten()
      end
    end
  end

  defmacro def_html(rich_text_block, do: block) when is_list(rich_text_block) do
    reversed_block = Enum.reverse(rich_text_block)

    quote do
      def html_block(unquote(reversed_block)) do
        unquote(block)
      end
    end
  end

  defmacro def_html(rich_text_block, do: block) do
    quote do
      def html_block(unquote([rich_text_block])) do
        unquote(block)
      end
    end
  end

  # coveralls-ignore-end
end
