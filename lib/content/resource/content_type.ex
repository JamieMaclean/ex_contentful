defmodule ExContentful.Resource.ContentType do
  @moduledoc """
  ContentType is one of the Contentful base resources. This struct can be used in conjunction with any of the `Query` modules to access and update any of your ContentTypes in Contentful
  """
  defstruct [:fields, :sys, :metadata]

  @type t :: %ExContentful.Resource.ContentType{
          fields: list(map()),
          sys: map(),
          metadata: map()
        }

  alias ExContentful.Resource.ContentType
  alias ExContentful.Resource.Link

  @doc false
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

  defimpl ExContentful.Resource do
    def base_url(_content_type, :content_management) do
      ExContentful.ContentManagement.url() <> "/content_types"
    end

    def prepare_for_contentful(_content_type) do
      raise "Not implemented"
    end
  end
end
