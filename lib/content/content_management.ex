defmodule Content.ContentManagement do
  @base_url "https://api.contentful.com"

  alias Content.ContentManagement.Query
  alias Content.HTTP
  alias Content.Resource.ContentType

  def url,
    do: "#{@base_url}/spaces/#{Content.space_id()}/environments/#{Content.environment_id()}"

  def migrate_content_model() do
    {:ok, items} = Query.get_all(%ContentType{})

    Enum.each(Content.content_types(), fn content_type ->
      case Enum.find(items, fn item ->
             item.sys.id == content_type.__contentful_schema__.id
           end) do
        nil -> upsert_content_type(content_type, 1)
        item -> upsert_content_type(content_type, item.sys.version)
      end
    end)
  end

  def upsert_content_type(content_type_module, version) do
    url = url() <> "/content_types/#{content_type_module.__contentful_schema__.id}"

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
