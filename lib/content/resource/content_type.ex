defmodule Content.Resource.ContentType do
  defstruct [:fields, :sys, :metadata]

  @type t :: %Content.Resource.ContentType{
          fields: list(map()),
          sys: map(),
          metadata: map()
        }

  alias Content.Resource.ContentType
  alias Content.Resource.Link

  def build_from_response(response) do
    {:ok, created_at, _} = DateTime.from_iso8601(response["sys"]["createdAt"])
    {:ok, updated_at, _} = DateTime.from_iso8601(response["sys"]["updatedAt"])

    fields =
      Enum.map(response["fields"], fn fields ->
        Enum.into(fields, [])
        |> Enum.map(fn {field, value} -> {String.to_existing_atom(field), value} end)
        |> Enum.into(%{})
      end)

    %ContentType{
      fields: fields,
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
        type: "ContentType",
        updated_at: updated_at,
        updated_by: %Link{
          id: response["sys"]["updatedBy"]["sys"]["id"],
          link_type: response["sys"]["updatedBy"]["sys"]["linkType"],
          type: response["sys"]["updatedBy"]["sys"]["type"]
        },
        version: response["sys"]["version"]
      }
    }
  end

  defimpl Content.Resource do
    def base_url(_content_type, :content_management) do
      Content.ContentManagement.url() <> "/content_types"
    end
  end
end
