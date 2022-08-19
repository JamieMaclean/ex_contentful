defmodule Content.Api.ContentManagement do
  alias Content.Entry
  alias Content.HTTP

  @moduledoc """
  The Content Management API is used to create and update content on
  Contentful.
  """

  @base_url "https://api.contentful.com"

  def access_token(),
    do:
      Application.get_env(:content, :content_management_token)

  def update_content_type(content_type_module, version, space_id, environment_id) do
    content_type = struct(content_type_module)

    url =
      "#{@base_url}/spaces/#{space_id}/environments/#{environment_id}/content_types/#{content_type.__id__}"

    body = Entry.to_contentful_schema(content_type)
           |> Jason.encode!()

    {:ok, %{body: _body}} =
      url
      |> HTTPoison.put(body, headers(content_type, version), hackney: [:insecure])
  end

  def upsert_entry(entry, version, space_id, environment_id) do
    url = "#{@base_url}/spaces/#{space_id}/environments/#{environment_id}/entries"

    body =
      Entry.to_contentful_entry(entry)
      |> Jason.encode!()

    {:ok, %{body: _body}} =
      url
      |> HTTPoison.post(body, headers(entry, version), HTTP.local_request_opts())
  end

  def headers(entry, version) do
    headers = [
      {"Authorization", "Bearer #{access_token()}"},
      {"Content-Type", "application/vnd.contentful.management.v1+json"},
      {"X-Contentful-Content-Type", entry.__id__}
    ]

    case version do
      1 -> headers
      _ -> [{"X-Contentful-Version", version} | headers]
    end
  end
end
