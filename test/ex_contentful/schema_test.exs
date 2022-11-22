defmodule ExContentful.Integration.SchemaTest do
  use ExUnit.Case

  alias ExContentful.Integration.BlogPost

  test "Creates the content model to be sent to contentful" do
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
                   id: "feature_image",
                   linkType: "Asset",
                   localized: false,
                   name: "Feature Image",
                   omitted: false,
                   required: false,
                   type: "Link"
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
                   items: %{type: "Symbol"}
                 },
                 %{
                   id: "author",
                   linkType: "Entry",
                   localized: false,
                   name: "Author",
                   omitted: false,
                   required: false,
                   type: "Link"
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
               displayField: "title",
               id: "blog_post",
               name: "Blog Post"
             }
  end
end
