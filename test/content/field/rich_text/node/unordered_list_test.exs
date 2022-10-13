defmodule Content.Field.RichText.Node.UnorderedListTest do
  use ExUnit.Case

  alias Content.Field.RichText.ValidationError
  alias Content.Field.RichText.Node
  alias Content.Field.RichText.Node.UnorderedList
  alias Content.Field.RichText.Node.ListItem
  alias Content.Field.RichText.Node.Text

  describe "Node.validate/1" do
    test "returns the paragraph when content is empty" do
      node = %UnorderedList{content: []}

      assert Node.validate(node) == node
    end

    test "returns error when content is invalid" do
      node = %UnorderedList{content: [%Text{}, %ListItem{}, %Text{}]}

      assert %ValidationError{node: ^node, received: [%Text{}, %Text{}]} = Node.validate(node)
    end

    test "returns the document when valid" do
      node = %UnorderedList{content: [%ListItem{}]}

      assert Node.validate(node) == node
    end
  end
end
