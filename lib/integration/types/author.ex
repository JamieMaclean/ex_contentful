defmodule ExContentful.Integration.Author do
  @moduledoc false
  use ExContentful.Schema

  content_type :author do
    content_field(:name, :short_text)
    content_field(:bio, :short_text)
    # change to asset when possible
    content_field(:picture, :short_text)
  end
end
