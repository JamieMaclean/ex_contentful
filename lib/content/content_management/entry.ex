defmodule Content.ContentManagement.Entry do
  alias Content.Entry
  alias Content.HTTP

  @moduledoc """
  The Content Management API is used to create and update content on
  Contentful.
  """
  def space_id(), do: Application.get_env(:content, :space_id)
  def environment_id(), do: Application.get_env(:content, :environment_id)

  @base_url Content.ContentManagement.url() <> "/entries"

  def upsert_entry(entry, version) do
    url = @base_url

    body =
      Entry.to_contentful_entry(entry)
      |> Jason.encode!()

    {:ok, %{body: _body}} =
      url
      |> HTTPoison.post(
        body,
        HTTP.headers([:auth, :contentful_type, :version],
          contentful_type: entry.__struct__,
          version: version
        ),
        hackney: [:insecure]
      )
  end

  def get_entry(entry_id) do
    url = "#{@base_url}//#{entry_id}"

    {:ok, %{body: _body}} =
      url
      |> HTTPoison.get(HTTP.headers([:auth]), hackney: [:insecure])
  end
end
