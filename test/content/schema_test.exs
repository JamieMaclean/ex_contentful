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
        omitted: true,
        available_options: ["asdf"]
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

  test "Default Contentful schema correctly" do
    assert MyDefaultContentType.contentful_schema() == %{
             fields: %{
               array_of_long_text: %{
                 cardinality: :many,
                 contentful_type: "Text",
                 id: "array_of_long_text",
                 localized: false,
                 name: "Array Of Long Text",
                 omitted: false,
                 required: false,
                 type: :string
               },
               array_of_short_text: %{
                 cardinality: :many,
                 contentful_type: "Symbol",
                 id: "array_of_short_text",
                 localized: false,
                 name: "Array Of Short Text",
                 omitted: false,
                 required: false,
                 type: :string
               },
               long_text_field: %{
                 cardinality: :one,
                 contentful_type: "Text",
                 id: "long_text_field",
                 localized: false,
                 name: "Long Text Field",
                 omitted: false,
                 required: false,
                 type: :string
               },
               short_text_field: %{
                 cardinality: :one,
                 contentful_type: "Symbol",
                 id: "short_text_field",
                 localized: false,
                 name: "Short Text Field",
                 omitted: false,
                 required: false,
                 type: :string
               }
             },
             id: "my_content_type",
             name: "My Content Type"
           }
  end

  test "Custom Contentful schema correctly" do
    assert MyCustomContentType.contentful_schema() == %{
             fields: %{
               array_of_long_text: %{
                 cardinality: :many,
                 contentful_type: "Text",
                 id: :custom_array_id,
                 localized: true,
                 name: "Custom Array Name",
                 omitted: true,
                 required: true,
                 type: :string
               },
               array_of_short_text: %{
                 cardinality: :many,
                 contentful_type: "Symbol",
                 id: :custom_array_id,
                 localized: true,
                 name: "Custom Array Name",
                 omitted: true,
                 required: true,
                 type: :string
               },
               long_text_field: %{
                 cardinality: :one,
                 contentful_type: "Text",
                 id: :custom_long_text_id,
                 localized: true,
                 name: "Custom Long Text Name",
                 omitted: true,
                 required: true,
                 type: :string
               },
               short_text_field: %{
                 cardinality: :one,
                 contentful_type: "Symbol",
                 id: :custom_short_text_id,
                 localized: true,
                 name: "Custom Short Text Name",
                 omitted: true,
                 required: true,
                 type: :string
               }
             },
             id: "a_custom_id",
             name: "A Custom Name"
           }
  end
end
