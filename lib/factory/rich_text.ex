defmodule ExContentful.Factory.RichText do
  @moduledoc false

  alias ExContentful.Field.RichText.Node.Document
  alias ExContentful.Field.RichText.Node.Paragraph
  alias ExContentful.Field.RichText.Node.Blockquote
  alias ExContentful.Field.RichText.Node.Text
  alias ExContentful.Field.RichText.Node.Hr

  alias ExContentful.Field.RichText.Node.{
    Heading1,
    Heading2,
    Heading3,
    Heading4,
    Heading5,
    Heading6
  }

  def build(node, args \\ %{})

  def build(:document, args) do
    struct(%Document{}, args)
  end

  def build(:heading_1, args) do
    struct(%Heading1{}, args)
  end

  def build(:heading_2, args) do
    struct(%Heading2{}, args)
  end

  def build(:heading_3, args) do
    struct(%Heading3{}, args)
  end

  def build(:heading_4, args) do
    struct(%Heading4{}, args)
  end

  def build(:heading_5, args) do
    struct(%Heading5{}, args)
  end

  def build(:heading_6, args) do
    struct(%Heading6{}, args)
  end

  def build(:paragraph, args) do
    struct(%Paragraph{}, args)
  end

  def build(:hr, args) do
    struct(%Hr{}, args)
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
