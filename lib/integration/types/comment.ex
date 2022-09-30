defmodule Content.Integration.Comment do
  @moduledoc false
  use Content.Schema

  content_type :comment do
    content_field(:blog_post_id, :short_text)
    content_field(:comment, :long_text)
  end
end
