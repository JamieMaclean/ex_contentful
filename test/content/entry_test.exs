defmodule Content.EntryTest do
  use ExUnit.Case

  alias Content.Entry
  alias Content.Integration.BlogPost

  test "Correctly transforms an entry to be sent to contentful" do
    assert Entry.to_contentful_entry(%BlogPost{
             title: "A long piece of text",
             content: "Some long content",
             authors: ["Jim", "Dave", "Fred"],
             legacy_field: "A legacy field"
           }) == %{
             fields: %{
               "authors" => %{"en-US" => ["Jim", "Dave", "Fred"]},
               "content" => %{"en-US" => "Some long content"},
               "legacy_field" => %{"en-US" => "A legacy field"},
               "title" => %{"en-US" => "A long piece of text"}
             }
           }
  end
end
