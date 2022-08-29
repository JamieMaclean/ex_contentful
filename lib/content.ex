defmodule Content do
  alias Content.Api.ContentManagement, as: CMApi

  def space_id(), do: Application.get_env(:content, :space_id)
  def environment_id(), do: Application.get_env(:content, :environment_id)

  def create_entry(entry), do: CMApi.upsert_entry(entry, 1, space_id(), environment_id())

  def update_entry(entry, version),
    do: CMApi.upsert_entry(entry, version, space_id(), environment_id())

  def create_content_type(content_type),
    do: CMApi.update_content_type(content_type, 1, space_id(), environment_id())

  def update_content_type(content_type, version),
    do: CMApi.update_content_type(content_type, version, space_id(), environment_id())

  def get_entry(entry_id) do
    {:ok, %{body: body}} = CMApi.get_entry(entry_id, space_id(), environment_id())

    entry = Jason.decode!(body)
    entry_type_id = get_in(entry, ["sys", "contentType", "sys", "id"])
    IO.inspect(:application.get_key(:content, :modules))
  end
end
