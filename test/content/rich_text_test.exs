defmodule Content.RichTextTest do
  use ExUnit.Case

  alias Content.Factory.RichText, as: Factory
  alias Content.Field.RichText.Node.Document
  alias Content.Field.RichText.Node.Paragraph
  alias Content.Field.RichText.Node.Text
  alias Content.Integration.RichText, as: RichText

  describe "block/1" do
    test "returns a value on a match" do
      nodes = [
        Factory.build(:paragraph, %{
          content: [
            Factory.build(:text, %{value: "matched bold text"})
          ]
        }),
        Factory.build(:paragraph, %{
          content: [
            Factory.build(:text, %{value: "Second paragraph"})
          ]
        })
      ]

      assert RichText.parse_content(nodes) == :asdf
    end

    test "returns a value on a matchadsf" do
      node = Factory.build(:paragraph, %{})

      assert RichText.parse_content([node]) == {"p", [], "just a pargraph"}
    end

    test "returns a value with remainder" do
      node =
        Factory.build(:paragraph, %{
          content: [
            Factory.build(:text, %{value: "Text in a paragraph"})
          ]
        })

      assert RichText.parse_content([node]) == :asdf
    end
  end
end
