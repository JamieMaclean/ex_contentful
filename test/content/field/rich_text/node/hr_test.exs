defmodule Content.Field.RichText.Node.HrTest do
  use ExUnit.Case

  alias Content.Field.RichText.ValidationError
  alias Content.Field.RichText.Node
  alias Content.Field.RichText.Node.Hr
  alias Content.Field.RichText.Node.Text

  describe "Node.validate/1" do
    test "returns the paragraph when content is empty" do
      node = %Hr{content: []}

      assert Node.validate(node) == node
    end

    test "returns error when content is invalid" do
      node = %Hr{content: [%Text{}, %Text{}]}

      assert %ValidationError{node: ^node, recieved: [%Text{}, %Text{}]} = Node.validate(node)
    end
  end
end
