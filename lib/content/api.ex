defmodule Content.Api do
  @moduledoc false
  alias Content.Resource.Entry
  alias Content.Resource.Link

  def to_entry(%{"sys" => %{"type" => "Entry"}} = entry, content_type_module) do
    {:ok, created_at, _} = DateTime.from_iso8601(entry["sys"]["createdAt"])
    {:ok, updated_at, _} = DateTime.from_iso8601(entry["sys"]["updatedAt"])

    {:ok, fields} =
      Enum.into(entry["fields"], [])
      |> Enum.map(fn {key, %{"en-US" => value}} -> {String.to_existing_atom(key), value} end)
      |> Enum.into(%{})
      |> content_type_module.create()

    %Entry{
      entry: fields,
      metadata: %{tags: []},
      sys: %{
        id: entry["sys"]["id"],
        created_at: created_at,
        content_type: %Link{
          id: entry["sys"]["contentType"]["sys"]["id"],
          link_type: entry["sys"]["contentType"]["sys"]["linkType"],
          type: entry["sys"]["contentType"]["sys"]["type"]
        },
        created_by: %Link{
          id: entry["sys"]["createdBy"]["sys"]["id"],
          link_type: entry["sys"]["createdBy"]["sys"]["linkType"],
          type: entry["sys"]["createdBy"]["sys"]["type"]
        },
        environment: %Link{
          id: entry["sys"]["environment"]["sys"]["id"],
          link_type: entry["sys"]["environment"]["sys"]["linkType"],
          type: entry["sys"]["environment"]["sys"]["type"]
        },
        published_counter: entry["sys"]["publishedCounter"],
        space: %Link{
          id: entry["sys"]["space"]["sys"]["id"],
          link_type: entry["sys"]["space"]["sys"]["linkType"],
          type: entry["sys"]["space"]["sys"]["type"]
        },
        type: "Entry",
        updated_at: updated_at,
        updated_by: %Link{
          id: entry["sys"]["updatedBy"]["sys"]["id"],
          link_type: entry["sys"]["updatedBy"]["sys"]["linkType"],
          type: entry["sys"]["updatedBy"]["sys"]["type"]
        },
        version: entry["sys"]["version"]
      }
    }
  end
end
