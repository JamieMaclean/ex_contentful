defmodule Content.Field.RichTextTest do
  use ExUnit.Case

  alias Content.Field.RichText
  alias Content.Field.RichText.Node.Document
  alias Content.Field.RichText.Node.Paragraph
  alias Content.Field.RichText.Node.Text

  describe "parse/1" do
    test "return a document" do
      node = %{"nodeType" => "document", "data" => %{}, "content" => []}
      assert RichText.parse(node) == %Document{content: []}
    end

    test "return a document with text" do
      node = %{
        "nodeType" => "document",
        "data" => %{},
        "content" => [
          %{
            "nodeType" => "paragraph",
            "data" => %{},
            "content" => [
              %{
                "nodeType" => "text",
                "data" => %{},
                "marks" => [],
                "value" => "some text"
              }
            ]
          }
        ]
      }

      assert RichText.parse(node) == %Document{
               content: [
                 %Paragraph{
                   content: [
                     %Text{value: "some text"}
                   ]
                 }
               ]
             }
    end
  end
end
