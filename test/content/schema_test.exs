defmodule Content.Integration.SchemaTest do
  use ExUnit.Case

  alias Content.Integration.BlogPost

  test "Correctly transforms short_text to be sent as an entry" do
    assert BlogPost.__contentful_schema__() ==
             %{
               fields: [
                 %{
                   type: "Symbol",
                   id: "legacy_field",
                   localized: true,
                   name: "An unused legacy field",
                   omitted: true,
                   required: true
                 },
                 %{
                   type: "Integer",
                   id: "views",
                   localized: false,
                   name: "Views",
                   omitted: false,
                   required: true
                 },
                 %{
                   type: "Number",
                   id: "rating",
                   localized: false,
                   name: "Rating",
                   omitted: false,
                   required: false
                 },
                 %{
                   id: "authors",
                   localized: false,
                   name: "Authors",
                   omitted: false,
                   required: false,
                   type: "Array",
                   items: %{type: "Symbol", validations: []}
                 },
                 %{
                   type: "RichText",
                   id: "content",
                   localized: false,
                   name: "Content",
                   omitted: false,
                   required: false
                 },
                 %{
                   type: "Symbol",
                   id: "title",
                   localized: false,
                   name: "Title",
                   omitted: false,
                   required: false
                 }
               ],
               displayField: "nil",
               id: "blog_post",
               name: "Blog Post"
             }
  end
end
