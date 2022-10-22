defmodule Content.Factory.RichText do
  @moduledoc false

  alias Content.Field.RichText.Node.Document
  alias Content.Field.RichText.Node.Paragraph
  alias Content.Field.RichText.Node.Blockquote
  alias Content.Field.RichText.Node.Text

  def build(node, args \\ %{})

  def build(:document, args) do
    struct(%Document{}, args)
  end

  def build(:paragraph, args) do
    struct(%Paragraph{}, args)
  end

  def build(:text, args) do
    struct(%Text{value: "Hello World!"}, args)
  end

  def build(:blockquote, args) do
    struct(%Blockquote{}, args)
  end

  def build(:full_document, _args) do
    build(
      :document,
      %{
        content: [
          build(:paragraph, %{
            content: [build(:text)]
          })
        ]
      }
    )
  end
end
