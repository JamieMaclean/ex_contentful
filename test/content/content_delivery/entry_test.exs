defmodule Content.ContentDelivery.EntryTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Content.Resource.Link
  alias Content.Error
  alias Content.Integration.BlogPost
  alias Content.Integration.Comment
  alias Content.ContentDelivery

  describe "get/2" do
    test "gets an entry" do
      use_cassette "content_delivery_get" do
        assert %BlogPost{
                 authors: [],
                 content: %{},
                 id: "6KxUwJQ8bTaKOrLJNrJ8Hl",
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
                   created_at: _,
                   environment: %Link{
                     id: "master",
                     link_type: "Environment",
                     type: "Link"
                   },
                   id: "6KxUwJQ8bTaKOrLJNrJ8Hl",
                   space: %Link{
                     id: "g8l7lpiniu90",
                     link_type: "Space",
                     type: "Link"
                   },
                   type: "Entry"
                 }
               } = ContentDelivery.get(%BlogPost{}, "6KxUwJQ8bTaKOrLJNrJ8Hl")
      end
    end

    test "returns a content type mismatch content type is not expected" do
      use_cassette "content_delivery_get_with_error" do
        expected_type = Comment.__contentful_schema__().id
        received_type = BlogPost.__contentful_schema__().id

        assert %Error{
                 type: :content_type_mismatch,
                 details: %{
                   expected: ^expected_type,
                   received: ^received_type,
                   response: _response
                 }
               } = ContentDelivery.get(%Comment{}, "6KxUwJQ8bTaKOrLJNrJ8Hl")
      end
    end
  end
end
