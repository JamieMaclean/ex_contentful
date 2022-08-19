defmodule Content.FieldTest do
  use ExUnit.Case

  alias Content.Field

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
    assert Field.to_contentful_schema(%MyDefaultContentType{}.__short_text_field__) == %{
             id: "short_text_field",
             type: "Symbol",
             localized: false,
             name: "Short Text Field",
             omitted: false,
             required: false
           }

    assert Field.to_contentful_schema(%MyDefaultContentType{}.__array_of_short_text__) == %{
             id: "array_of_short_text",
             type: "Array",
             items: %{type: "Symbol"},
             name: "Array Of Short Text",
             omitted: false
           }
  end

  test "Correctly transforms long_text to be sent to contentful" do
    assert Field.to_contentful_schema(%MyDefaultContentType{}.__long_text_field__) == %{
             id: "long_text_field",
             type: "Text",
             localized: false,
             name: "Long Text Field",
             omitted: false,
             required: false
           }

    assert Field.to_contentful_schema(%MyDefaultContentType{}.__array_of_long_text__) == %{
             id: "array_of_long_text",
             type: "Array",
             items: %{type: "Text"},
             name: "Array Of Long Text",
             omitted: false
           }
  end
end
