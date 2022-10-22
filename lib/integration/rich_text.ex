defmodule Content.Integration.RichText do
  @moduledoc false

  use Content.RichText
  alias Content.Field.RichText.Node.Document
  alias Content.Field.RichText.Node.Paragraph
  alias Content.Field.RichText.Node.Blockquote
  alias Content.Field.RichText.Node.Text

  def get_attributes(%Paragraph{content: [%Text{}, %Blockquote{}]}) do
    [
      {"class", "aClass"}
    ]
  end

  def to_html(_), do: :todo

  def parse_content(_), do: :todo
end
