defmodule ExContentful.ResourceTest do
  use ExUnit.Case

  alias ExContentful.Resource
  alias ExContentful.Integration.BlogPost

  test "Correctly transforms an entry to be sent to contentful" do
    assert Resource.prepare_for_contentful(%BlogPost{
             title: "A long piece of text",
             content: "Some long content",
             authors: ["Jim", "Dave", "Fred"],
             legacy_field: "A legacy field",
             rating: 4.7,
             views: 287
           }) == %{
             fields: %{
               "authors" => %{"en-US" => ["Jim", "Dave", "Fred"]},
               "content" => %{"en-US" => "Some long content"},
               "legacy_field" => %{"en-US" => "A legacy field"},
               "title" => %{"en-US" => "A long piece of text"},
               "views" => %{"en-US" => 287},
               "rating" => %{"en-US" => 4.7},
               "author" => %{"en-US" => ""},
               "feature_image" => %{"en-US" => ""}
             }
           }
  end
end
