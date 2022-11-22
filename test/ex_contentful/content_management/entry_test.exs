defmodule ExContentful.ContentManagement.EntryTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias ExContentful.Resource.Entry
  alias ExContentful.Resource.Link
  alias ExContentful.Error
  alias ExContentful.Integration.BlogPost
  alias ExContentful.Integration.Author
  alias ExContentful.ContentManagement
  alias ExContentful.Factory.RichText

  describe "create/1" do
    @tag :only
    test "creates an entry" do
      use_cassette "create_entry" do
        {:ok, blog_post} = BlogPost.create(%{views: 123, content: RichText.build(:full_document)})

        assert {:ok,
                %BlogPost{
                  authors: [],
                  content: _,
                  id: _,
                  legacy_field: _,
                  rating: nil,
                  title: _,
                  views: _,
                  metadata: %{tags: []},
                  sys: %{
                    content_type: %Link{
                      id: "blog_post",
                      link_type: "ContentType",
                      type: "Link"
                    },
                    created_at: _,
                    created_by: %Link{
                      id: "5J5TUlcInAPSw6zfv557d7",
                      link_type: "User",
                      type: "Link"
                    },
                    environment: %Link{
                      id: "integration",
                      link_type: "Environment",
                      type: "Link"
                    },
                    id: _,
                    published_counter: 0,
                    space: %Link{
                      id: "g8l7lpiniu90",
                      link_type: "Space",
                      type: "Link"
                    },
                    type: "Entry",
                    updated_at: _,
                    updated_by: %Link{
                      id: _,
                      link_type: "User",
                      type: "Link"
                    },
                    version: 1
                  }
                }} = ContentManagement.create(blog_post)
      end
    end
  end

  describe "get/2" do
    test "gets an entry" do
      use_cassette "entry" do
        assert ContentManagement.get(%BlogPost{}, "1ovcGJESEykRotOaKuTRtE") ==
                 %BlogPost{
                   authors: [],
                   content: %{},
                   id: "1ovcGJESEykRotOaKuTRtE",
                   legacy_field: "",
                   rating: nil,
                   title: "",
                   views: 123,
                   metadata: %{tags: []},
                   sys: %{
                     content_type: %Link{
                       id: "blog_post",
                       link_type: "ContentType",
                       type: "Link"
                     },
                     created_at: ~U[2022-09-25 18:16:18.350Z],
                     created_by: %Link{
                       id: "5J5TUlcInAPSw6zfv557d7",
                       link_type: "User",
                       type: "Link"
                     },
                     environment: %Link{
                       id: "integration",
                       link_type: "Environment",
                       type: "Link"
                     },
                     id: "1ovcGJESEykRotOaKuTRtE",
                     published_counter: 0,
                     space: %Link{
                       id: "g8l7lpiniu90",
                       link_type: "Space",
                       type: "Link"
                     },
                     type: "Entry",
                     updated_at: ~U[2022-09-25 18:16:18.350Z],
                     updated_by: %Link{
                       id: "5J5TUlcInAPSw6zfv557d7",
                       link_type: "User",
                       type: "Link"
                     },
                     version: 1
                   }
                 }
      end
    end

    test "returns a content type mismatch content type is not expected" do
      use_cassette "entry" do
        expected_type = Author.__contentful_schema__().id
        received_type = BlogPost.__contentful_schema__().id

        assert %Error{
                 type: :content_type_mismatch,
                 details: %{
                   expected: ^expected_type,
                   received: ^received_type,
                   response: _response
                 }
               } = ContentManagement.get(%Author{}, "1ovcGJESEykRotOaKuTRtE")
      end
    end
  end

  describe "get_all/1" do
    test "gets all entries for space" do
      use_cassette "get_all_entries" do
        assert {:ok, _list} = ContentManagement.get_all(%Entry{})
      end
    end
  end

  describe "upsert/1" do
    test "creates a new entry when the id does not exist" do
      use_cassette "upsert_as_create_entry" do
        {:ok, blog_post} =
          BlogPost.create(%{
            views: 12_345,
            content: RichText.build(:full_document)
          })

        assert %BlogPost{
                 authors: [],
                 content: _,
                 id: _,
                 legacy_field: "",
                 metadata: %{tags: []},
                 rating: nil,
                 sys: %{
                   content_type: %Link{
                     id: "blog_post",
                     link_type: "ContentType",
                     type: "Link"
                   },
                   created_at: _,
                   created_by: %Link{
                     id: "5J5TUlcInAPSw6zfv557d7",
                     link_type: "User",
                     type: "Link"
                   },
                   environment: %Link{
                     id: "integration",
                     link_type: "Environment",
                     type: "Link"
                   },
                   id: _,
                   published_counter: 0,
                   space: %Link{
                     id: "g8l7lpiniu90",
                     link_type: "Space",
                     type: "Link"
                   },
                   type: "Entry",
                   updated_at: _,
                   updated_by: %Link{
                     id: "5J5TUlcInAPSw6zfv557d7",
                     link_type: "User",
                     type: "Link"
                   },
                   version: 1
                 },
                 title: "",
                 views: 12_345
               } = ContentManagement.upsert(blog_post, "3abade73-5615-4b1e-92a2-ce5b3b2bdf0")
      end
    end

    test "updates an new entry when the id exists" do
      use_cassette "upsert_as_update_entry" do
        {:ok, blog_post} =
          BlogPost.create(%{
            views: 1,
            content: RichText.build(:full_document)
          })

        assert %BlogPost{
                 authors: [],
                 content: _,
                 id: "3abade73-5615-4b1e-92a2-ce5b3b2bdf7f",
                 legacy_field: "",
                 metadata: %{tags: []},
                 rating: nil,
                 sys: %{
                   content_type: %Link{
                     id: "blog_post",
                     link_type: "ContentType",
                     type: "Link"
                   },
                   created_at: _,
                   created_by: %Link{
                     id: "5J5TUlcInAPSw6zfv557d7",
                     link_type: "User",
                     type: "Link"
                   },
                   environment: %Link{
                     id: "integration",
                     link_type: "Environment",
                     type: "Link"
                   },
                   id: "3abade73-5615-4b1e-92a2-ce5b3b2bdf7f",
                   published_counter: 0,
                   space: %Link{
                     id: "g8l7lpiniu90",
                     link_type: "Space",
                     type: "Link"
                   },
                   type: "Entry",
                   updated_at: _,
                   updated_by: %Link{
                     id: "5J5TUlcInAPSw6zfv557d7",
                     link_type: "User",
                     type: "Link"
                   },
                   version: _
                 },
                 title: "",
                 views: _
               } =
                 ContentManagement.upsert(blog_post, "3abade73-5615-4b1e-92a2-ce5b3b2bdf7f",
                   version: 1
                 )
      end
    end

    test "returns version mismatch error when the version is wrong" do
      use_cassette "upsert_as_update_fail" do
        {:ok, blog_post} =
          BlogPost.create(%{
            views: 1,
            content: RichText.build(:full_document)
          })

        assert %Error{
                 details: %{
                   response: %{
                     "requestId" => _,
                     "sys" => %{"id" => "VersionMismatch", "type" => "Error"}
                   }
                 },
                 type: :version_mismatch
               } =
                 ContentManagement.upsert(blog_post, "3abade73-5615-4b1e-92a2-ce5b3b2bdf7f",
                   version: 100
                 )
      end
    end
  end

  describe "delete/1" do
    test "returns not found error when the id does not exist" do
      use_cassette "delete_entry_not_found" do
        assert ContentManagement.delete(%BlogPost{}, "3abade73-5615-4b1e-92a2-ce5b3b2bdf7f",
                 version: 2
               ) == %Error{
                 details: %{
                   response: %{
                     "details" => %{
                       "environment" => "integration",
                       "id" => "3abade73-5615-4b1e-92a2-ce5b3b2bdf7f",
                       "space" => "g8l7lpiniu90",
                       "type" => "Entry"
                     },
                     "message" => "The resource could not be found.",
                     "requestId" => "75ddada7-8ca1-4d92-bd0f-59421ee11eb3",
                     "sys" => %{"id" => "NotFound", "type" => "Error"}
                   }
                 },
                 type: :resource_not_found
               }
      end
    end

    test "deletes an entry" do
      use_cassette "delete_entry" do
        assert ContentManagement.delete(%BlogPost{}, "5nGIcgPywsB0qBjzrI1sUX", version: 2) == :ok
      end
    end
  end
end
