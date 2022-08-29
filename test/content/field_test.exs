defmodule Content.FieldTest do
  use ExUnit.Case

  alias Content.Field

  defmodule MyDefaultContentType do
    use Content.Schema

    contentful_type :my_content_type do
      contentful_field(:short_text_field, :short_text)
      contentful_fields(:array_of_short_text, :short_text)
      contentful_field(:long_text_field, :long_text)
      contentful_fields(:array_of_long_text, :long_text)
    end
  end

  test "Correctly transforms short_text to be sent to contentful" do
    assert true
  end
end
