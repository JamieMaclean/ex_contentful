defmodule ExContentful.Field.RichText.Node.ListItemTest do
  use ExUnit.Case

  alias ExContentful.Field.RichText.ValidationError
  alias ExContentful.Field.RichText.Node
  alias ExContentful.Field.RichText.Node.ListItem
  alias ExContentful.Field.RichText.Node.Paragraph
  alias ExContentful.Field.RichText.Node.Text

  describe "Node.validate/1" do
    test "returns the paragraph when content is empty" do
      node = %ListItem{content: []}

      assert Node.validate(node) == node
    end

    test "returns error when content is invalid" do
      node = %ListItem{content: [%Text{}, %Paragraph{}, %Text{}]}

      assert %ValidationError{node: ^node, received: [%Text{}, %Text{}]} = Node.validate(node)
    end

    test "returns the document when valid" do
      node = %ListItem{content: [%Paragraph{}]}

      assert Node.validate(node) == node
    end
  end
end
