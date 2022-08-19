defmodule Content.EntryTest do
  use ExUnit.Case

  alias Content.Entry

  defmodule MyDefaultContentType do
    use Content.Schema

    contentful_type :my_content_type do
      contentful_field(:short_text_field, :short_text)
      contentful_fields(:array_of_short_text, :short_text)
      contentful_field(:long_text_field, :long_text)
      contentful_fields(:array_of_long_text, :long_text)
    end
  end

  test "Correctly transforms short_text to be sent to contentful" do
    assert Entry.to_contentful_schema(%MyDefaultContentType{}) == %{
             name: "My Content Type",
             fields: [
               %{
                 items: %{type: "Text"},
                 name: "Array Of Long Text",
                 omitted: false,
                 type: "Array"
               },
               %{
                 items: %{type: "Symbol"},
                 name: "Array Of Short Text",
                 omitted: false,
                 type: "Array"
               },
               %{
                 localized: false,
                 name: "Long Text Field",
                 omitted: false,
                 required: false,
                 type: "Text"
               },
               %{
                 localized: false,
                 name: "Short Text Field",
                 omitted: false,
                 required: false,
                 type: "Symbol"
               }
             ]
           }
  end
end
