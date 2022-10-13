defmodule Content.Field.RichText.Node.BlockquoteTest do
  use ExUnit.Case

  alias Content.Field.RichText.ValidationError
  alias Content.Field.RichText.Node
  alias Content.Field.RichText.Node.Blockquote
  alias Content.Field.RichText.Node.Paragraph
  alias Content.Field.RichText.Node.Text

  describe "Node.validate/1" do
    test "returns the paragraph when content is empty" do
      node = %Blockquote{content: []}

      assert Node.validate(node) == node
    end

    test "returns error when content is invalid" do
      node = %Blockquote{content: [%Text{}, %Paragraph{}, %Text{}]}

      assert %ValidationError{node: ^node, received: [%Text{}, %Text{}]} = Node.validate(node)
    end

    test "returns the document when valid" do
      node = %Blockquote{content: [%Paragraph{}]}

      assert Node.validate(node) == node
    end
  end
end
