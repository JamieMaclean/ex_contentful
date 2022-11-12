defmodule ExContentful.Field.RichText.Node.TableCellTest do
  use ExUnit.Case

  alias ExContentful.Field.RichText.ValidationError
  alias ExContentful.Field.RichText.Node
  alias ExContentful.Field.RichText.Node.TableCell
  alias ExContentful.Field.RichText.Node.Paragraph
  alias ExContentful.Field.RichText.Node.Text

  describe "Node.validate/1" do
    test "returns the node when content is empty" do
      node = %TableCell{content: []}

      assert Node.validate(node) == node
    end

    test "returns error when content is invalid" do
      node = %TableCell{content: [%Text{}, %Paragraph{}, %Text{}]}

      assert %ValidationError{node: ^node, received: [%Text{}, %Text{}]} = Node.validate(node)
    end

    test "returns the node when valid" do
      node = %TableCell{content: [%Paragraph{}]}

      assert Node.validate(node) == node
    end
  end
end
