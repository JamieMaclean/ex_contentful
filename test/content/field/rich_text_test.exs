defmodule Content.Field.RichTextTest do
  use ExUnit.Case

  alias Content.Factory.ContentfulRichText
  alias Content.Field.RichText
  alias Content.Field.RichText.Node.Document
  alias Content.Field.RichText.Node.Paragraph
  alias Content.Field.RichText.Node.Text
  alias Content.Field.RichText.Node.OrderedList
  alias Content.Field.RichText.Node.UnorderedList
  alias Content.Field.RichText.Node.ListItem

  alias Content.Field.RichText.Node.{
    Heading1,
    Heading2,
    Heading3,
    Heading4,
    Heading5,
    Heading6
  }

  describe "parse/1" do
    test "return a document" do
      document = ContentfulRichText.build(:block, %{"nodeType" => "document"})
      assert RichText.parse(document) == %Document{content: []}
    end

    test "return a document with text" do
      document =
        ContentfulRichText.build(:document, %{
          "content" => [
            ContentfulRichText.build(:paragraph, %{
              "content" => [
                ContentfulRichText.build(:text, %{"value" => "some text"})
              ]
            })
          ]
        })

      assert RichText.parse(document) == %Document{
               content: [
                 %Paragraph{
                   content: [
                     %Text{value: "some text"}
                   ]
                 }
               ]
             }
    end

    test "return a document with all heading types" do
      document =
        ContentfulRichText.build(:document, %{
          "content" => [
            ContentfulRichText.build(:heading_1, %{
              "content" => [
                ContentfulRichText.build(:text, %{"value" => "Heading 1"})
              ]
            }),
            ContentfulRichText.build(:heading_2, %{
              "content" => [
                ContentfulRichText.build(:text, %{"value" => "Heading 2"})
              ]
            }),
            ContentfulRichText.build(:heading_3, %{
              "content" => [
                ContentfulRichText.build(:text, %{"value" => "Heading 3"})
              ]
            }),
            ContentfulRichText.build(:heading_4, %{
              "content" => [
                ContentfulRichText.build(:text, %{"value" => "Heading 4"})
              ]
            }),
            ContentfulRichText.build(:heading_5, %{
              "content" => [
                ContentfulRichText.build(:text, %{"value" => "Heading 5"})
              ]
            }),
            ContentfulRichText.build(:heading_6, %{
              "content" => [
                ContentfulRichText.build(:text, %{"value" => "Heading 6"})
              ]
            })
          ]
        })

      assert RichText.parse(document) == %Document{
               content: [
                 %Heading1{
                   content: [
                     %Text{value: "Heading 1"}
                   ]
                 },
                 %Heading2{
                   content: [
                     %Text{value: "Heading 2"}
                   ]
                 },
                 %Heading3{
                   content: [
                     %Text{value: "Heading 3"}
                   ]
                 },
                 %Heading4{
                   content: [
                     %Text{value: "Heading 4"}
                   ]
                 },
                 %Heading5{
                   content: [
                     %Text{value: "Heading 5"}
                   ]
                 },
                 %Heading6{
                   content: [
                     %Text{value: "Heading 6"}
                   ]
                 }
               ]
             }
    end

    test "return a document with all list types" do
      document =
        ContentfulRichText.build(:document, %{
          "content" => [
            ContentfulRichText.build(:ordered_list, %{
              "content" => [
                ContentfulRichText.build(:list_item, %{
                  "content" => [
                    ContentfulRichText.build(:text, %{"value" => "item in ordered list"})
                  ]
                })
              ]
            }),
            ContentfulRichText.build(:unordered_list, %{
              "content" => [
                ContentfulRichText.build(:list_item, %{
                  "content" => [
                    ContentfulRichText.build(:text, %{"value" => "item in unordered list"})
                  ]
                })
              ]
            })
          ]
        })

      assert RichText.parse(document) == %Document{
               content: [
                 %OrderedList{
                   content: [
                     %ListItem{
                       content: [
                         %Text{value: "item in ordered list"}
                       ]
                     }
                   ]
                 },
                 %UnorderedList{
                   content: [
                     %ListItem{
                       content: [
                         %Text{value: "item in unordered list"}
                       ]
                     }
                   ]
                 }
               ]
             }
    end
  end
end
