defmodule Content.SchemaTest do
  use ExUnit.Case

  defmodule MyDefaultContentType do
    use Content.Schema

    contentful_type :my_content_type do
      contentful_field(:short_text_field, :short_text)
      contentful_fields(:array_of_short_text, :short_text)
      contentful_field(:long_text_field, :long_text)
      contentful_fields(:array_of_long_text, :long_text)
    end
  end

  defmodule MyCustomContentType do
    use Content.Schema

    contentful_type :my_content_type, id: "a_custom_id", name: "A Custom Name" do
      contentful_field(:short_text_field, :short_text,
        id: :custom_short_text_id,
        name: "Custom Short Text Name",
        localized: true,
        required: true,
        omitted: true
      )

      contentful_fields(:array_of_short_text, :short_text,
        id: :custom_array_id,
        name: "Custom Array Name",
        localized: true,
        required: true,
        omitted: true
      )

      contentful_field(:long_text_field, :long_text,
        id: :custom_long_text_id,
        name: "Custom Long Text Name",
        localized: true,
        required: true,
        omitted: true
      )

      contentful_fields(:array_of_long_text, :long_text,
        id: :custom_array_id,
        name: "Custom Array Name",
        localized: true,
        required: true,
        omitted: true
      )
    end
  end

  test "Schema defaults are correctly assigned" do
    assert %MyDefaultContentType{} == %MyDefaultContentType{
             short_text_field: "",
             long_text_field: "",
             array_of_short_text: [],
             array_of_long_text: []
           }
  end

  test "Schema defaults are overwritten correctly" do
    assert %MyCustomContentType{} == %MyCustomContentType{
             short_text_field: "",
             array_of_short_text: [],
             array_of_long_text: []
           }
  end
end
