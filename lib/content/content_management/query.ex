defmodule Content.ContentManagement.Query do
  alias Content.HTTP
  alias Content.Resource

  def get(resource, id) do
    url = Resource.base_url(resource, :content_management) <> "/#{id}"

    url
    |> HTTPoison.get(HTTP.headers([:auth]), hackney: [:insecure])
    |> case do
      {:ok, %{body: body}} -> {:ok, Jason.decode!(body)}
      {:error, error} -> {:error, error}
    end
  end

  def get_all(resource) do
    url = Resource.base_url(resource, :content_management)

    url
    |> HTTPoison.get(HTTP.headers([:auth]), hackney: [:insecure])
    |> case do
      {:ok, %{body: body}} -> {:ok, Jason.decode!(body)}
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
end
