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
        id: :custom_short_text_id,
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
             __id__: "my_content_type",
             __name__: "My Content Type",
             __long_text_field__: %{
               cardinality: :one,
               contentful_type: "Text",
               id: "",
               localized: false,
               name: "Long Text Field",
               required: false,
               type: :string,
               omitted: false
             },
             __short_text_field__: %{
               cardinality: :one,
               contentful_type: "Symbol",
               id: "",
               localized: false,
               name: "Short Text Field",
               required: false,
               type: :string,
               omitted: false
             },
             __array_of_short_text__: %{
               cardinality: :many,
               contentful_type: "Symbol",
               id: "",
               localized: false,
               name: "Array Of Short Text",
               required: false,
               type: :string,
               omitted: false
             },
             __array_of_long_text__: %{
               cardinality: :many,
               contentful_type: "Text",
               id: "",
               localized: false,
               name: "Array Of Long Text",
               required: false,
               type: :string,
               omitted: false
             },
             short_text_field: "",
             long_text_field: "",
             array_of_short_text: [],
             array_of_long_text: []
           }
  end

  test "Schema defaults are overwritten correctly" do
    assert %MyCustomContentType{} == %MyCustomContentType{
             __id__: "a_custom_id",
             __name__: "A Custom Name",
             __long_text_field__: %{
               cardinality: :one,
               contentful_type: "Text",
               id: "",
               localized: true,
               name: "Custom Long Text Name",
               required: true,
               type: :string,
               omitted: true
             },
             __short_text_field__: %{
               cardinality: :one,
               contentful_type: "Symbol",
               id: "",
               localized: true,
               name: "Custom Short Text Name",
               required: true,
               type: :string,
               omitted: true
             },
             __array_of_short_text__: %{
               cardinality: :many,
               contentful_type: "Symbol",
               id: "",
               localized: true,
               name: "Custom Array Name",
               required: true,
               type: :string,
               omitted: true
             },
             __array_of_long_text__: %{
               cardinality: :many,
               contentful_type: "Text",
               id: "",
               localized: true,
               name: "Custom Array Name",
               required: true,
               type: :string,
               omitted: true
             },
             short_text_field: "",
             array_of_short_text: [],
             array_of_long_text: []
           }
  end
end
