defmodule ExContentful.Field.RichText.Node.OrderedListTest do
  use ExUnit.Case

  alias ExContentful.Field.RichText.ValidationError
  alias ExContentful.Field.RichText.Node
  alias ExContentful.Field.RichText.Node.OrderedList
  alias ExContentful.Field.RichText.Node.ListItem
  alias ExContentful.Field.RichText.Node.Text

  describe "Node.validate/1" do
    test "returns the list when content is empty" do
      node = %OrderedList{content: []}

      assert Node.validate(node) == node
    end

    test "returns error when content is invalid" do
      node = %OrderedList{content: [%Text{}, %ListItem{}, %Text{}]}

      assert %ValidationError{node: ^node, received: [%Text{}, %Text{}]} = Node.validate(node)
    end

    test "returns the list when valid" do
      node = %OrderedList{content: [%ListItem{}]}

      assert Node.validate(node) == node
    end
  end
end
