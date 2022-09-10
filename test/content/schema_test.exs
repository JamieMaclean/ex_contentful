defmodule Content.Integration.SchemaTest do
  use ExUnit.Case

  alias Content.Integration.BlogPost

  test "Correctly transforms short_text to be sent as an entry" do
    assert BlogPost.contentful_schema() ==
             %{
               fields: %{
                 authors: %{
                   available_options: [],
                   cardinality: :many,
                   contentful_type: "Symbol",
                   id: "authors",
                   localized: false,
                   name: "Authors",
                   omitted: false,
                   required: false,
                   type: :string
                 },
                 content: %{
                   cardinality: :one,
                   contentful_type: "Text",
                   id: "content",
                   localized: false,
                   name: "Content",
                   omitted: false,
                   required: false,
                   type: :string
                 },
                 title: %{
                   available_options: [],
                   cardinality: :one,
                   contentful_type: "Symbol",
                   id: "title",
                   localized: false,
                   name: "Title",
                   omitted: false,
                   required: false,
                   type: :string
                 },
                 legacy_field: %{
                   available_options: [],
                   cardinality: :one,
                   contentful_type: "Symbol",
                   id: "legacy_field",
                   localized: true,
                   name: "An unused legacy field",
                   omitted: true,
                   required: true,
                   type: :string
                 }
               },
               id: "blog_post",
               name: "Blog Post"
             }
  end
end
