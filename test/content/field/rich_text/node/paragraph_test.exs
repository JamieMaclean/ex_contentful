defmodule Content.Field.RichText.Node.ParagraphTest do
  use ExUnit.Case

  alias Content.Field.RichText.ValidationError
  alias Content.Field.RichText.Node
  alias Content.Field.RichText.Node.Paragraph
  alias Content.Field.RichText.Node.Text

  describe "Node.validate/1" do
    test "returns the paragraph when content is empty" do
      node = %Paragraph{content: []}

      assert Node.validate(node) == node
    end

    test "returns error when content is invalid" do
      node = %Paragraph{content: [%Paragraph{}, %Text{}, %Paragraph{}]}

      assert %ValidationError{node: ^node, received: [%Paragraph{}, %Paragraph{}]} =
               Node.validate(node)
    end

    test "returns the paragraph when valid" do
      node = %Paragraph{content: [%Text{}]}

      assert Node.validate(node) == node
    end
  end
end
