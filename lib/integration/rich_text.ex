defmodule Content.Integration.RichText do
  use Content.RichText
  alias Content.Field.RichText.Node.Document
  alias Content.Field.RichText.Node.Paragraph
  alias Content.Field.RichText.Node.Blockquote
  alias Content.Field.RichText.Node.Text

  def to_html(%Document{} = node, data) do
    Enum.map(node.content, &to_html(&1, data))
    |> Floki.raw_html()
  end

  def get_attributes(%Paragraph{content: [%Text{}, %Blockquote{}]}) do
    [
      {"class", "aClass"}
    ]
  end
end
