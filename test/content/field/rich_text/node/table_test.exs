defmodule Content.Field.RichText.Node.TableTest do
  use ExUnit.Case

  alias Content.Field.RichText.ValidationError
  alias Content.Field.RichText.Node
  alias Content.Field.RichText.Node.Table
  alias Content.Field.RichText.Node.TableRow
  alias Content.Field.RichText.Node.Text

  describe "Node.validate/1" do
    test "returns the paragraph when content is empty" do
      node = %Table{content: []}

      assert Node.validate(node) == node
    end

    test "returns error when content is invalid" do
      node = %Table{content: [%Text{}, %TableRow{}, %Text{}]}

      assert %ValidationError{node: ^node, recieved: [%Text{}, %Text{}]} = Node.validate(node)
    end

    test "returns the document when valid" do
      node = %Table{content: [%TableRow{}]}

      assert Node.validate(node) == node
    end
  end
end
