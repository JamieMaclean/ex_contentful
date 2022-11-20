defmodule ExContentful.ContentManagement.Query.ContentTypeTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias ExContentful.Resource.ContentType
  alias ExContentful.ContentManagement

  describe "get/2" do
    test "get a content type from an id" do
      use_cassette "content_type_get" do
        assert %ExContentful.Resource.ContentType{
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
                     required: false,
                     type: "RichText",
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
                 sys: %{
                   content_type: %ExContentful.Resource.Link{id: nil, link_type: nil, type: nil},
                   created_at: _,
                   created_by: %ExContentful.Resource.Link{
                     id: "5J5TUlcInAPSw6zfv557d7",
                     link_type: "User",
                     type: "Link"
                   },
                   environment: %ExContentful.Resource.Link{
                     id: "integration",
                     link_type: "Environment",
                     type: "Link"
                   },
                   id: "blog_post",
                   published_counter: _,
                   space: %ExContentful.Resource.Link{
                     id: "g8l7lpiniu90",
                     link_type: "Space",
                     type: "Link"
                   },
                   type: "ContentType",
                   updated_at: _,
                   updated_by: %ExContentful.Resource.Link{
                     id: "5J5TUlcInAPSw6zfv557d7",
                     link_type: "User",
                     type: "Link"
                   },
                   version: _
                 },
                 metadata: %{tags: []}
               } = ContentManagement.get(%ContentType{}, "blog_post")
      end
    end
  end

  describe "get_all/1" do
    test "gets all content types in an environment" do
      use_cassette "content_type_get_all" do
        assert {
                 :ok,
                 [
                   %ExContentful.Resource.ContentType{
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
                         required: false,
                         type: "RichText",
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
                       content_type: %ExContentful.Resource.Link{
                         id: nil,
                         link_type: nil,
                         type: nil
                       },
                       created_at: _,
                       created_by: %ExContentful.Resource.Link{
                         id: "5J5TUlcInAPSw6zfv557d7",
                         link_type: "User",
                         type: "Link"
                       },
                       environment: %ExContentful.Resource.Link{
                         id: "integration",
                         link_type: "Environment",
                         type: "Link"
                       },
                       id: "blog_post",
                       published_counter: _,
                       space: %ExContentful.Resource.Link{
                         id: "g8l7lpiniu90",
                         link_type: "Space",
                         type: "Link"
                       },
                       type: "ContentType",
                       updated_at: _,
                       updated_by: %ExContentful.Resource.Link{
                         id: "5J5TUlcInAPSw6zfv557d7",
                         link_type: "User",
                         type: "Link"
                       },
                       version: _
                     }
                   },
                   %ExContentful.Resource.ContentType{
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
                       content_type: %ExContentful.Resource.Link{
                         id: nil,
                         link_type: nil,
                         type: nil
                       },
                       created_at: _,
                       created_by: %ExContentful.Resource.Link{
                         id: "5J5TUlcInAPSw6zfv557d7",
                         link_type: "User",
                         type: "Link"
                       },
                       environment: %ExContentful.Resource.Link{
                         id: "integration",
                         link_type: "Environment",
                         type: "Link"
                       },
                       id: "comment",
                       published_counter: 0,
                       space: %ExContentful.Resource.Link{
                         id: "g8l7lpiniu90",
                         link_type: "Space",
                         type: "Link"
                       },
                       type: "ContentType",
                       updated_at: _,
                       updated_by: %ExContentful.Resource.Link{
                         id: "5J5TUlcInAPSw6zfv557d7",
                         link_type: "User",
                         type: "Link"
                       },
                       version: _
                     }
                   }
                 ]
               } = ContentManagement.get_all(%ContentType{})
      end
    end
  end
end
