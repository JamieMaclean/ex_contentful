defmodule Content.ParserTest do
  use ExUnit.Case

  alias Content.Parser
  alias Content.Integration.BlogPost

  test "Correctly retrieves the correct content type from an id" do
    assert nil == Parser.get_content_type("an_invalid_id")
    assert BlogPost == Parser.get_content_type("blog_post")
  end

  test "Parser starts with application" do
    assert {:error, {:already_started, pid}} = Parser.start_link([])
    assert is_pid(pid)
  end
end
