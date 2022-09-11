defmodule Content.Api do
  alias Content.Api.ContentManagement, as: CMApi
  alias Content.Entry

  def space_id(), do: Application.get_env(:content, :space_id)
  def environment_id(), do: Application.get_env(:content, :environment_id)

  def create_entry(entry), do: CMApi.upsert_entry(entry, 1, space_id(), environment_id())

  def update_entry(entry, version),
    do: CMApi.upsert_entry(entry, version, space_id(), environment_id())

  def migrate_content_model(application) do
    app_content_types = Entry.all(application)
    %{"items" => items} = CMApi.all_content_types(space_id(), environment_id())

    Enum.each(app_content_types, fn content_type ->
      case Enum.find(items, fn item -> item.id == content_type.__contentful_schema__.id end) do
        nil -> create_content_type(content_type)
        item -> update_content_type(content_type, item.version)
      end
    end)
  end

  def create_content_type(content_type),
    do: CMApi.update_content_type(content_type, 1, space_id(), environment_id())

  def update_content_type(content_type, version),
    do: CMApi.update_content_type(content_type, version, space_id(), environment_id())

  def get_entry(entry_id) do
    CMApi.all_content_types(space_id(), environment_id())
    |> IO.inspect()

    raise "asdf"

    CMApi.get_entry(entry_id, space_id(), environment_id())
    |> IO.inspect()
  end
end
