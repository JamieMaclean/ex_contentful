defmodule Content.ContentManagement.Query do
  alias Content.HTTP
  alias Content.Resource
  alias Content.Resource.ContentType
  alias Content.Error

  def get(resource, id) do
    url = Resource.base_url(resource, :content_management) <> "/#{id}"

    url
    |> HTTPoison.get(HTTP.headers([:auth]), hackney: [:insecure])
    |> case do
      {:ok, %{body: body}} -> process_response(resource, Jason.decode!(body))
      {:error, error} -> {:error, error}
    end
  end

  def get_all(resource) do
    url = Resource.base_url(resource, :content_management)

    url
    |> HTTPoison.get(HTTP.headers([:auth]), hackney: [:insecure])
    |> case do
      {:ok, %{body: body}} -> {:ok, process_response(resource, Jason.decode!(body))}
      {:error, error} -> {:error, error}
    end
  end

  def delete(resource, id, version: version) do
    url = Resource.base_url(resource, :content_management) <> "/#{id}"

    url
    |> HTTPoison.delete(HTTP.headers([:auth, :version], version: version), hackney: [:insecure])
    |> case do
      {:ok, %{body: body}} -> {:ok, Jason.decode!(body)}
      {:error, error} -> {:error, error}
    end
  end

  defp process_response(
         expected_type,
         %{"items" => items}
       ) do
    Enum.map(items, &process_response(expected_type, &1))
  end

  defp process_response(
         expected_type,
         %{"sys" => %{"contentType" => %{"sys" => %{"id" => content_type_id}}, "type" => "Entry"}} =
           body
       ) do
    if expected_type.__struct__.__contentful_schema__.id == content_type_id do
      expected_type.__struct__.build_from_response(body)
    else
      {:error,
       %Error{
         type: :content_type_missmatch,
         details: %{
           expected: expected_type.__struct__.__contentful_schema__.id,
           received: content_type_id,
           response: body
         }
       }}
    end
  end

  defp process_response(
         _expected_type,
         %{"sys" => %{"type" => "ContentType"}} = body
       ) do
    ContentType.build_from_response(body)
  end
end
