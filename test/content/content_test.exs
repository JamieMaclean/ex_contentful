defmodule Content.ContentTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Content.Integration.BlogPost
  alias Content.Integration.Content.ContentManagement

  setup_all do
    start_supervised!(Content.Integration.Content)
    :ok
  end

  test "Correctly retrieves the correct content type from an id" do
    assert nil == Content.Integration.Content.get_content_type("an_invalid_id")
    assert BlogPost == Content.Integration.Content.get_content_type("blog_post")

    use_cassette "content_type" do
      ContentManagement.migrate_content_model()
    end
  end
end
