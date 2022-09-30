defmodule Content.ContentManagement.ContentType do
  alias Content.ContentManagement.Query
  alias Content.HTTP
  alias Content.Resource.ContentType

  @moduledoc """
  The Content Management API is used to create and update content on
  Contentful.
  """

  defp base_url, do: Content.ContentManagement.url() <> "/content_types"

  def migrate_content_model(app_content_types) do
    {:ok, %{"items" => items}} = Query.get_all(%ContentType{})

    Enum.each(app_content_types, fn content_type ->
      case Enum.find(items, fn item ->
             item["sys"]["id"] == content_type.__contentful_schema__.id
           end) do
        nil -> upsert_content_type(content_type, 1)
        item -> upsert_content_type(content_type, item["sys"]["version"])
      end
    end)
  end

  def upsert_content_type(content_type_module, version) do
    url = "#{base_url()}/#{content_type_module.__contentful_schema__.id}"

    body =
      content_type_module.__contentful_schema__
      |> Map.delete(:id)
      |> Jason.encode!()

    url
    |> HTTPoison.put(
      body,
      HTTP.headers([:auth, :contentful_type, :version],
        contentful_type: content_type_module,
        version: version
      ),
      hackney: [:insecure]
    )
    |> HTTP.process_response()
  end
end
