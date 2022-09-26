defmodule Content.ContentManagement.EntryTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Content.Integration.Content.ContentManagement

  setup_all do
    start_supervised!(Content.Integration.Content)
    :ok
  end

  test "gets an entry" do
    use_cassette "entry" do
      assert ContentManagement.get_entry("1ovcGJESEykRotOaKuTRtE") == %Content.Resource.Entry{
               entry: %Content.Integration.BlogPost{
                 authors: [],
                 content: "asdfasdf",
                 id: nil,
                 legacy_field: "",
                 rating: nil,
                 title: "",
                 views: 123
               },
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
             }
    end
  end
end
