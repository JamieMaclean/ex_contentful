defmodule ExContentful.RichText do
  @moduledoc """
  Defines the set of functions used to convert Rich Text to HTML.

  ## Basic Usage
  Default implementations are provided for each of the function in this module. These default implementations convert Rich Text into basic HTML only with no attributes or styles. There are various ways of customising the functions but the basic usage is as follows.

  ```elixir
  defmodule MyApp.RichText do
    use ExContentful.RichText
  end

  raw_html_binary = MyApp.to_html(rich_text)
  ```

  For example:
  ```elixir
  alias MyApp.RichText

  rich_text = %ExContentful.Field.RichText.Node.Document{
  content: [
    %ExContentful.Field.RichText.Node.Paragraph{
      content: [
        %ExContentful.Field.RichText.Node.Text{
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
end
