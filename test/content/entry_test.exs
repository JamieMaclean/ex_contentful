defmodule Content.EntryTest do
  use ExUnit.Case

  alias Content.Entry

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

  test "Correctly transforms short_text to be sent as an entry" do
    assert Entry.to_contentful_entry(%MyDefaultContentType{
             long_text_field: "A long piece of text"
           }) == %{
             fields: %{
               "array_of_long_text" => %{"en-US" => []},
               "array_of_short_text" => %{"en-US" => []},
               "long_text_field" => %{"en-US" => "A long piece of text"},
               "short_text_field" => %{"en-US" => ""}
             }
           }
  end
end
