defmodule Content.Integration.BlogPost do
  use Content.Schema

  content_type :blog_post do
    content_field(:title, :short_text)
    content_field(:content, :long_text)
    content_field_array(:authors, :short_text)

    content_field(:legacy_field, :short_text,
      name: "An unused legacy field",
      localized: true,
      required: true,
      omitted: true
    )
  end
end
