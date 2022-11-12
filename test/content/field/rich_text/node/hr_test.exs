defmodule ExContentful.Field.RichText.Node.HrTest do
  use ExUnit.Case

  alias ExContentful.Field.RichText.ValidationError
  alias ExContentful.Field.RichText.Node
  alias ExContentful.Field.RichText.Node.Hr
  alias ExContentful.Field.RichText.Node.Text

  describe "Node.validate/1" do
    test "returns the hr when content is empty" do
      node = %Hr{content: []}

      assert Node.validate(node) == node
    end

    test "returns error when content is invalid" do
      node = %Hr{content: [%Text{}, %Text{}]}

      assert %ValidationError{node: ^node, received: [%Text{}, %Text{}]} = Node.validate(node)
    end
  end
end
