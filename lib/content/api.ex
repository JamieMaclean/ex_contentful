defmodule Content.Api do
  alias Content.Api.ContentManagement, as: CMApi

  def space_id(), do: Application.get_env(:sylar, __MODULE__)[:space_id]
  def environment_id(), do: Application.get_env(:sylar, __MODULE__)[:environment_id]

  def create_entry(entry), do: CMApi.upsert_entry(entry, 1, space_id(), environment_id())

  def update_entry(entry, version),
    do: CMApi.upsert_entry(entry, version, space_id(), environment_id())

  def create_content_type(content_type),
    do: CMApi.update_content_type(content_type, 1, space_id(), environment_id())

  def update_content_type(content_type, version),
    do: CMApi.update_content_type(content_type, version, space_id(), environment_id())

  def get_entry(entry_id) do
    CMApi.get_entry(entry_id, space_id(), environment_id())
    |> IO.inspect()
  end
end
