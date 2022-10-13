defmodule Content.Field.RichText.Node.TableRowTest do
  use ExUnit.Case

  alias Content.Field.RichText.ValidationError
  alias Content.Field.RichText.Node
  alias Content.Field.RichText.Node.TableRow
  alias Content.Field.RichText.Node.TableCell
  alias Content.Field.RichText.Node.TableHeaderCell
  alias Content.Field.RichText.Node.Text

  describe "Node.validate/1" do
    test "returns the paragraph when content is empty" do
      node = %TableRow{content: []}

      assert Node.validate(node) == node
    end

    test "returns error when content is invalid" do
      node = %TableRow{content: [%Text{}, %TableHeaderCell{}, %TableCell{}, %Text{}]}

      assert %ValidationError{node: ^node, received: [%Text{}, %Text{}]} = Node.validate(node)
    end

    test "returns the document when valid" do
      node = %TableRow{content: [%TableCell{}, %TableHeaderCell{}]}

      assert Node.validate(node) == node
    end
  end
end
