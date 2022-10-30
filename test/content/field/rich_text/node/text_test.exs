defmodule Content.Field.RichText.Node.TextTest do
  use ExUnit.Case

  alias Content.Field.RichText.ValidationError
  alias Content.Field.RichText.Node
  alias Content.Field.RichText.Node.Text
  alias Content.Integration.RichText, as: Integration
  alias Content.Factory.RichText

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

  describe "Node.to_html/1" do
    @tag :skip
    test "returns the html for the node" do
      node = RichText.build(:text, %{value: "Some text"})

      assert Integration.to_html(node, nil) == {"Some text", nil}
    end

    @tag :skip
    test "wraps text in marks" do
      bold = RichText.build(:text, %{value: "Some text", marks: [%{type: "bold"}]})
      italic = RichText.build(:text, %{value: "Some text", marks: [%{type: "italic"}]})
      underline = RichText.build(:text, %{value: "Some text", marks: [%{type: "underline"}]})
      code = RichText.build(:text, %{value: "Some text", marks: [%{type: "code"}]})

      all =
        RichText.build(:text, %{
          value: "Some text",
          marks: [%{type: "bold"}, %{type: "underline"}, %{type: "italic"}, %{type: "code"}]
        })

      assert Integration.to_html(bold, nil) == {"<b>Some text</b>", nil}
      assert Integration.to_html(italic, nil) == {"<em>Some text</em>", nil}
      assert Integration.to_html(underline, nil) == {"<u>Some text</u>", nil}
      assert Integration.to_html(code, nil) == {"<code>Some text</code>", nil}

      assert Integration.to_html(all, nil) ==
               {"<code><em><u><b>Some text</b></u></em></code>", nil}
    end
  end
end
