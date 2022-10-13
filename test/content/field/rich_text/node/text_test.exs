defmodule Content.Field.RichText.Node.TextTest do
  use ExUnit.Case

  alias Content.Field.RichText.ValidationError
  alias Content.Field.RichText.Node
  alias Content.Field.RichText.Node.Text
  alias Content.Field.RichText.Node.Text.Mark

  describe "Node.validate/1" do
    test "returns the text when it is valid" do
      node = %Text{value: "a valid value", marks: [%Mark{type: "bold"}]}

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
      node = %Text{marks: [%Mark{type: "invalid"}, %Mark{type: "bold"}, %{type: "bold"}]}

      assert %ValidationError{node: ^node, received: [%Mark{type: "invalid"}, %{type: "bold"}]} =
               Node.validate(node)
    end
  end
end
