defmodule Content.ContentManagement.Query.ContentTypeTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Content.Resource.ContentType
  alias Content.ContentManagement.Query

  setup_all do
    start_supervised!(Content.Integration.Content)
    :ok
  end

  describe "get/2" do
    test "gets an entry" do
      use_cassette "content_type" do
        assert Query.get_all(%ContentType{}) ==
                 {
                   :ok,
                   [
                     %Content.Resource.ContentType{
                       fields: [
                         %{
                           disabled: false,
                           id: "comment",
                           localized: false,
                           name: "Comment",
                           omitted: false,
                           required: false,
                           type: "Text",
                           validations: []
                         },
                         %{
                           disabled: false,
                           id: "blog_post_id",
                           localized: false,
                           name: "Blog Post Id",
                           omitted: false,
                           required: false,
                           type: "Symbol",
                           validations: []
                         }
                       ],
                       metadata: %{tags: []},
                       sys: %{
                         content_type: %Content.Resource.Link{id: nil, link_type: nil, type: nil},
                         created_at: ~U[2022-09-30 15:38:42.726Z],
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
                         id: "comment",
                         published_counter: 0,
                         space: %Content.Resource.Link{
                           id: "g8l7lpiniu90",
                           link_type: "Space",
                           type: "Link"
                         },
                         type: "Entry",
                         updated_at: ~U[2022-09-30 15:38:43.564Z],
                         updated_by: %Content.Resource.Link{
                           id: "5J5TUlcInAPSw6zfv557d7",
                           link_type: "User",
                           type: "Link"
                         },
                         version: 2
                       }
                     },
                     %Content.Resource.ContentType{
                       fields: [
                         %{
                           disabled: false,
                           id: "legacy_field",
                           localized: true,
                           name: "An unused legacy field",
                           omitted: true,
                           required: true,
                           type: "Symbol",
                           validations: []
                         },
                         %{
                           disabled: false,
                           id: "views",
                           localized: false,
                           name: "Views",
                           omitted: false,
                           required: true,
                           type: "Integer",
                           validations: []
                         },
                         %{
                           disabled: false,
                           id: "rating",
                           localized: false,
                           name: "Rating",
                           omitted: false,
                           required: false,
                           type: "Number",
                           validations: []
                         },
                         %{
                           disabled: false,
                           id: "authors",
                           items: %{"type" => "Symbol", "validations" => []},
                           localized: false,
                           name: "Authors",
                           omitted: false,
                           required: false,
                           type: "Array",
                           validations: []
                         },
                         %{
                           disabled: false,
                           id: "content",
                           localized: false,
                           name: "Content",
                           omitted: false,
                           required: true,
                           type: "Text",
                           validations: []
                         },
                         %{
                           disabled: false,
                           id: "title",
                           localized: false,
                           name: "Title",
                           omitted: false,
                           required: false,
                           type: "Symbol",
                           validations: []
                         }
                       ],
                       metadata: %{tags: []},
                       sys: %{
                         content_type: %Content.Resource.Link{id: nil, link_type: nil, type: nil},
                         created_at: ~U[2022-09-11 08:55:33.224Z],
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
                         id: "blog_post",
                         published_counter: 9,
                         space: %Content.Resource.Link{
                           id: "g8l7lpiniu90",
                           link_type: "Space",
                           type: "Link"
                         },
                         type: "Entry",
                         updated_at: ~U[2022-09-26 10:36:57.922Z],
                         updated_by: %Content.Resource.Link{
                           id: "5J5TUlcInAPSw6zfv557d7",
                           link_type: "User",
                           type: "Link"
                         },
                         version: 42
                       }
                     }
                   ]
                 }
      end
    end
  end
end
