defmodule Content.Resource.Entry do
  @moduledoc """
  Entry is one of the Contentful base resources. This struct can be used in conjunction with any of the `Query` modules to access and update any of your Entries in Contentful
  """
  defstruct [:entry, :sys, :metadata]

  @type t :: %Content.Resource.Entry{
    entry: struct(),
    sys: map(),
    metadata: map()
  }

  alias Content.Resource.Link

  def build_from_response(response) do
    {:ok, created_at, _} = DateTime.from_iso8601(response["sys"]["createdAt"])
    {:ok, updated_at, _} = DateTime.from_iso8601(response["sys"]["updatedAt"])

    %{fields: response["fields"]}
    |> Map.merge(%{
      metadata: %{tags: []},
      sys: %{
        id: response["sys"]["id"],
        created_at: created_at,
        content_type: %Link{
          id: response["sys"]["contentType"]["sys"]["id"],
          link_type: response["sys"]["contentType"]["sys"]["linkType"],
          type: response["sys"]["contentType"]["sys"]["type"]
        },
        created_by: %Link{
          id: response["sys"]["createdBy"]["sys"]["id"],
          link_type: response["sys"]["createdBy"]["sys"]["linkType"],
          type: response["sys"]["createdBy"]["sys"]["type"]
        },
        environment: %Link{
          id: response["sys"]["environment"]["sys"]["id"],
          link_type: response["sys"]["environment"]["sys"]["linkType"],
          type: response["sys"]["environment"]["sys"]["type"]
        },
        published_counter: response["sys"]["publishedCounter"],
        space: %Link{
          id: response["sys"]["space"]["sys"]["id"],
          link_type: response["sys"]["space"]["sys"]["linkType"],
          type: response["sys"]["space"]["sys"]["type"]
        },
        type: "Entry",
        updated_at: updated_at,
        updated_by: %Link{
          id: response["sys"]["updatedBy"]["sys"]["id"],
          link_type: response["sys"]["updatedBy"]["sys"]["linkType"],
          type: response["sys"]["updatedBy"]["sys"]["type"]
        },
        version: response["sys"]["version"]
        }
      })
  end

  defimpl Content.Resource do
    def prepare_for_contentful(_content_type) do
      :ok
    end

    def base_url(_content_type, :content_management) do
      Content.ContentManagement.url() <> "/entries"
    end
  end
end
