defmodule Content.RichText do
  @moduledoc """
  Defines the set of functions used to convert Rich Text to HTML.

  ## Basic Usage
  Default implementations are provided for each of the function in this module. These default implementations convert Rich Text into basic HTML only with no attributes or styles. There are various ways of customising the functions but the basic usage is as follows.

  ```elixir
  defmodule MyApp.RichText do
    use Content.RichText
  end

  raw_html_binary = MyApp.to_html(rich_text)
  ```

  For example:
  ```elixir
  alias MyApp.RichText

  rich_text = %Content.Field.RichText.Node.Document{
  content: [
    %Content.Field.RichText.Node.Paragraph{
      content: [
        %Content.Field.RichText.Node.Text{
          data: %{},
          marks: [],
          node_type: "text",
          value: "Some text"
        }
      ],
      data: %{},
      node_type: "paragraph"
    }
  ],
  data: %{},
  node_type: "document"
  }

  RichText.to_html(rich_text)
  "<p>Some text</p>"
  ```

  ## Customisation

  It is unlikely that the basic implementation of `to_html/1` will provide the functionality to style and theme the content. There are therefore that can be extended and through the magic of pattern matching, you can find and customise the Rich Text as you see fit.
  """

  @doc """
  Takes a Rich Text node and optional data, and returns a Floki 3 item HTML tuple.
  """
  @callback to_html(document :: struct()) :: String.t()
  @callback to_html(node :: struct(), data :: any()) :: {struct(), any()}
  @callback get_attributes(node :: struct()) :: list(tuple())
  @callback parse_content(content :: list(struct()), html :: list(struct()), data :: any()) ::
              {html_content :: list(struct()), data :: any()}

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

      def get_attributes(_) do
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
      import Content.RichText
      @behaviour Content.RichText

      Module.register_attribute(__MODULE__, :defattribute, accumulate: true)

      @before_compile Content.RichText
    end
  end
end
