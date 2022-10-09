defmodule Content.ContentManagement.Query.EntryTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Content.Resource.Entry
  alias Content.Error
  alias Content.Integration.BlogPost
  alias Content.Integration.Comment
  alias Content.ContentManagement.Query

  describe "create/1" do
    test "creates an entry" do
      use_cassette "create_entry" do
        {:ok, blog_post} = BlogPost.create(%{views: 123, content: "some content"})

        assert Query.create(blog_post) ==
                 {:ok,
                  %Content.Integration.BlogPost{
                    authors: [],
                    content: "some content",
                    id: nil,
                    legacy_field: "",
                    rating: nil,
                    title: "",
                    views: 123,
                    metadata: %{tags: []},
                    sys: %{
                      content_type: %Content.Resource.Link{
                        id: "blog_post",
                        link_type: "ContentType",
                        type: "Link"
                      },
                      created_at: ~U[2022-10-02 22:01:54.712Z],
                      created_by: %Content.Resource.Link{
                        id: "5J5TUlcInAPSw6zfv557d7",
                        link_type: "User",
                        type: "Link"
                      },
                      environment: %Content.Resource.Link{
                        id: "integration",
                        link_type: "Environment",
                        type: "Link"
                      },
                      id: "3rpnMzTbz5WaWrotEHqkms",
                      published_counter: 0,
                      space: %Content.Resource.Link{
                        id: "g8l7lpiniu90",
                        link_type: "Space",
                        type: "Link"
                      },
                      type: "Entry",
                      updated_at: ~U[2022-10-02 22:01:54.712Z],
                      updated_by: %Content.Resource.Link{
                        id: "5J5TUlcInAPSw6zfv557d7",
                        link_type: "User",
                        type: "Link"
                      },
                      version: 1
                    }
                  }}
      end
    end
  end

  describe "get/2" do
    test "gets an entry" do
      use_cassette "entry" do
        assert Query.get(%BlogPost{}, "1ovcGJESEykRotOaKuTRtE") ==
                 {:ok,
                  %Content.Integration.BlogPost{
                    authors: [],
                    content: "asdfasdf",
                    id: nil,
                    legacy_field: "",
                    rating: nil,
                    title: "",
                    views: 123,
                    metadata: %{tags: []},
                    sys: %{
                      content_type: %Content.Resource.Link{
                        id: "blog_post",
                        link_type: "ContentType",
                        type: "Link"
                      },
                      created_at: ~U[2022-09-25 18:16:18.350Z],
                      created_by: %Content.Resource.Link{
                        id: "5J5TUlcInAPSw6zfv557d7",
                        link_type: "User",
                        type: "Link"
                      },
                      environment: %Content.Resource.Link{
                        id: "integration",
                        link_type: "Environment",
                        type: "Link"
                      },
                      id: "1ovcGJESEykRotOaKuTRtE",
                      published_counter: 0,
                      space: %Content.Resource.Link{
                        id: "g8l7lpiniu90",
                        link_type: "Space",
                        type: "Link"
                      },
                      type: "Entry",
                      updated_at: ~U[2022-09-25 18:16:18.350Z],
                      updated_by: %Content.Resource.Link{
                        id: "5J5TUlcInAPSw6zfv557d7",
                        link_type: "User",
                        type: "Link"
                      },
                      version: 1
                    }
                  }}
      end
    end

    test "returns a content type mismatch content type is not expected" do
      use_cassette "entry" do
        expected_type = Comment.__contentful_schema__().id
        received_type = BlogPost.__contentful_schema__().id

        assert {:error,
                %Error{
                  type: :content_type_missmatch,
                  details: %{
                    expected: ^expected_type,
                    received: ^received_type,
                    response: _response
                  }
                }} = Query.get(%Comment{}, "1ovcGJESEykRotOaKuTRtE")
      end
    end
  end

  describe "get_all/1" do
    test "gets all entries for space" do
      use_cassette "all_entries" do
        assert {:ok, _list} = Query.get_all(%Entry{})
      end
    end
  end
end
