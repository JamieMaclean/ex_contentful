defmodule Content.Integration.Attributes do
  @moduledoc false

  use Content.HTMLAttributes
  alias Content.Field.RichText.Node.Paragraph
  alias Content.Field.RichText.Node.Blockquote
  alias Content.Field.RichText.Node.Text

  def get_attributes(%Paragraph{content: [%Text{}, %Blockquote{}]}) do
    [
      {"class", "aClass"}
    ]
  end
end
