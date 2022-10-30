defmodule Content.RichTextTest do
  use ExUnit.Case

  alias Content.Factory.RichText, as: Factory
  alias Content.Integration.RichTextAdapter, as: Adapter
  alias Content.Integration.RichTextEmptyAdapter, as: EmptyAdapter

  describe "block/1" do
    test "returns a value on a matchadsf" do
      node =
        Factory.build(:paragraph, %{
          content: [
            Factory.build(:text, %{value: "just a paragraph"})
          ]
        })

      assert EmptyAdapter.parse_content([node]) == [{"p", [], ["just a paragraph"]}]
    end

    test "returns a value with remainder" do
      node =
        Factory.build(:paragraph, %{
          content: [
            Factory.build(:text, %{value: "Text in a paragraph"})
          ]
        })

      assert EmptyAdapter.parse_content([node]) == [{"p", [], ["Text in a paragraph"]}]
    end
  end

  describe "EmptyAdapter.to_html/1" do
    test "returns the html for the node" do
      node =
        Factory.build(:document, %{
          content: [
            Factory.build(:paragraph, %{
              content: [Factory.build(:text, %{value: "Some text"})]
            })
          ]
        })

      assert EmptyAdapter.to_html(node) == "<p>Some text</p>"
    end

    test "integration test - gets custom atributes" do
      node =
        Factory.build(:document, %{
          content: [
            Factory.build(:paragraph, %{
              content: [
                Factory.build(:text, %{value: "Text outside blockquote"}),
                Factory.build(:blockquote, %{
                  content: [
                    Factory.build(:paragraph, %{
                      content: [Factory.build(:text, %{value: "Text in Blockquote"})]
                    })
                  ]
                })
              ]
            })
          ]
        })

      assert EmptyAdapter.to_html(node) ==
               "<p>Text outside blockquote<blockquote><p>Text in Blockquote</p></blockquote></p>"
    end

    test "integration test - pattern matches custom impl" do
      node =
        Factory.build(:document, %{
          content: [
            Factory.build(:paragraph, %{
              content: [
                Factory.build(:text, %{value: "Some text"})
              ]
            })
          ]
        })

      assert EmptyAdapter.to_html(node) == "<p>Some text</p>"
    end

    test "retsdfasdurns the html for the node" do
      node = Factory.build(:text, %{value: "Some text"})

      assert EmptyAdapter.to_html([node]) == "Some text"
    end

    test "wraps text in marks" do
      bold = Factory.build(:text, %{value: "Some text", marks: [%{type: "bold"}]})
      italic = Factory.build(:text, %{value: "Some text", marks: [%{type: "italic"}]})
      underline = Factory.build(:text, %{value: "Some text", marks: [%{type: "underline"}]})
      code = Factory.build(:text, %{value: "Some text", marks: [%{type: "code"}]})

      all =
        Factory.build(:text, %{
          value: "Some text",
          marks: [%{type: "bold"}, %{type: "underline"}, %{type: "italic"}, %{type: "code"}]
        })

      assert EmptyAdapter.to_html(bold) == "<b>Some text</b>"
      assert EmptyAdapter.to_html(italic) == "<em>Some text</em>"
      assert EmptyAdapter.to_html(underline) == "<u>Some text</u>"
      assert EmptyAdapter.to_html(code) == "<code>Some text</code>"

      assert EmptyAdapter.to_html(all) == "<b><u><em><code>Some text</code></em></u></b>"
    end
  end

  describe "Adapter.to_html/1" do
    test "returns custom matched text" do
      node =
        Factory.build(:document, %{
          content: [
            Factory.build(:paragraph, %{
              content: [Factory.build(:text, %{value: "Change me to bold"})]
            })
          ]
        })

      assert Adapter.to_html(node) == "<p><b>Change me to bold</b></p>"
    end

    test "returns custom matched text when embedded in other html" do
      node =
        Factory.build(:document, %{
          content: [
            Factory.build(:paragraph, %{
              content: [
                Factory.build(:paragraph, %{
                  content: [Factory.build(:text, %{value: "Change me to bold"})]
                })
              ]
            })
          ]
        })

      assert Adapter.to_html(node) == "<p><p><b>Change me to bold</b></p></p>"
    end

    test "Can completely transform text for custom patterns" do
      node =
        Factory.build(:document, %{
          content: [
            Factory.build(:paragraph, %{
              content: [Factory.build(:text, %{value: "Before heading"})]
            }),
            Factory.build(:hr),
            Factory.build(:paragraph, %{
              content: [Factory.build(:text, %{value: "Change me to a heading"})]
            }),
            Factory.build(:hr),
            Factory.build(:paragraph, %{
              content: [Factory.build(:text, %{value: "After heading"})]
            })
          ]
        })

      assert Adapter.to_html(node) ==
               "<p>Before heading</p><h1>Change me to a heading</h1><p>After heading</p>"
    end
  end
end
