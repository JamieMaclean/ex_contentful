defmodule Content.Api.ContentManagement do
  alias Content.Entry
  alias Content.Api.HTTP

  @moduledoc """
  The Content Management API is used to create and update content on
  Contentful.
  """

  @base_url "https://api.contentful.com"

  def all_content_types(space_id, environment_id) do
    url = "#{@base_url}/spaces/#{space_id}/environments/#{environment_id}/content_types"

    url
    |> HTTPoison.get(HTTP.headers([:auth]), hackney: [:insecure])
    |> HTTP.process_response()
  end

  def update_content_type(content_type_module, version, space_id, environment_id) do
    url =
      "#{@base_url}/spaces/#{space_id}/environments/#{environment_id}/content_types/#{content_type_module.__contentful_schema__.id}"

    %{fields: fields} = schema = content_type_module.__contentful_schema__

    fields =
      Enum.map(fields, fn %{contentful_type: type} = field ->
        Map.delete(field, :cardinality)
        |> Map.delete(:available_options)
        |> Map.delete(:contentful_type)
        |> Map.put(:type, type)
      end)

    schema = Map.put(schema, :fields, fields)

    body =
      schema
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

  def upsert_entry(entry, version, space_id, environment_id) do
    url = "#{@base_url}/spaces/#{space_id}/environments/#{environment_id}/entries"

    body =
      Entry.to_contentful_entry(entry)
      |> Jason.encode!()

    {:ok, %{body: _body}} =
      url
      |> HTTPoison.post(
        body,
        HTTP.headers([:auth, :contentful_type, :version], contentful_type: entry, version: version),
        hackney: [:insecure]
      )
  end

  def get_entry(entry_id, space_id, environment_id) do
    url = "#{@base_url}/spaces/#{space_id}/environments/#{environment_id}/entries/#{entry_id}"

    {:ok, %{body: _body}} =
      url
      |> HTTPoison.get(HTTP.headers([:auth]), hackney: [:insecure])
  end
end
