defmodule Content.ContentManagement.Entry do
  alias Content.Entry
  alias Content.HTTP

  @moduledoc """
  The Content Management API is used to create and update content on
  Contentful.
  """

  def base_url, do: Content.ContentManagement.url() <> "/entries"

  def upsert_entry(entry, version) do
    url = base_url()

    body =
      Entry.to_contentful_entry(entry)
      |> Map.delete(:id)
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
end
