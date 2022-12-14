defmodule ExContentful.Field.RichText.Node.TextTest do
  use ExUnit.Case

  alias ExContentful.Field.RichText.ValidationError
  alias ExContentful.Field.RichText.Node
  alias ExContentful.Field.RichText.Node.Text

  describe "Node.validate/1" do
    test "returns the text when it is valid" do
      node = %Text{value: "a valid value", marks: [%{type: "bold"}]}

      assert Node.validate(node) == node
    end

    test "returns the text when content is empty" do
      node = %Text{}

      assert Node.validate(node) == node
    end

    test "returns validation error when the value is not a binary" do
      node = %Text{value: %{invalid: "text"}}

      assert %ValidationError{node: ^node, received: %{invalid: "text"}} = Node.validate(node)
    end

    test "returns validation error when incorrect marks are provided" do
      node = %Text{marks: [%{type: "invalid"}, %{type: "bold"}]}

      assert %ValidationError{node: ^node, received: [%{type: "invalid"}]} = Node.validate(node)
    end
  end
end
