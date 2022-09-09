defmodule Content.Integration.BlogPost do
  use Content.Schema

  contentful_type :blog_post do
    contentful_field(:title, :short_text)
    contentful_field(:content, :long_text)
    contentful_fields(:authors, :short_text)

    contentful_field(:legacy_field, :short_text,
      name: "An unused legacy field",
      localized: true,
      required: true,
      omitted: true
    )
  end
end
