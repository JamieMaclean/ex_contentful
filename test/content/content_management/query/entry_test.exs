defmodule Content.ContentManagement.Query.EntryTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Content.Error
  alias Content.Integration.BlogPost
  alias Content.Integration.Comment
  alias Content.ContentManagement.Query

  setup_all do
    start_supervised!(Content.Integration.Content)
    :ok
  end

  describe "get/2" do
    test "gets an entry" do
      use_cassette "entry" do
        assert Query.get(%BlogPost{}, "1ovcGJESEykRotOaKuTRtE") == {:ok, %Content.Integration.BlogPost{
          authors: [],
          content: "asdfasdf",
          id: nil,
          legacy_field: "",
          rating: nil,
          title: "",
          views: 123
        }}
      end
    end

    test "returns a version missmatch error when content type is not expected" do
      use_cassette "entry" do
        expected_type = Comment.__contentful_schema__.id
        received_type = BlogPost.__contentful_schema__.id
        assert {:error, %Error{type: :content_type_missmatch, details: %{
          expected: ^expected_type,
          received: ^received_type,
          response: _response
        }}} = Query.get(%Comment{}, "1ovcGJESEykRotOaKuTRtE")
      end
    end
  end
end
