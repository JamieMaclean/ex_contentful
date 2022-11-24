defmodule ExContentful.Integration.BlogPost do
  @moduledoc false
  use ExContentful.Schema

  alias ExContentful.Integration.Author

  content_type :blog_post, display_field: :title do
    content_field(:title, :short_text)
    content_field(:content, :rich_text)
    content_field(:author, Author)
    content_field(:authors, {:array, :short_text})
    content_field(:rating, :number)
    content_field(:views, :integer, required: true)
    content_field(:feature_image, :asset)

    content_field(:legacy_field, :short_text,
      name: "An unused legacy field",
      localized: true,
      required: true,
      omitted: true
    )
  end
end
