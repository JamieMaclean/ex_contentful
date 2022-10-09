defmodule Content.ContentManagement do
  @base_url "https://api.contentful.com"

  @moduledoc """
  This module can be used to access Contentful's Content Management API.

  This module provides some basic, composable functions that can be used to query any Contentful resource
  """

  alias Content.ContentManagement
  alias Content.Error
  alias Content.HTTP
  alias Content.Resource
  alias Content.Resource.ContentType
  alias Content.Resource.Entry
  alias Content.Resource.ContentType

  def url,
    do: "#{@base_url}/spaces/#{Content.space_id()}/environments/#{Content.environment_id()}"

  def migrate_content_model() do
    {:ok, items} = ContentManagement.get_all(%ContentType{})

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

  @doc """
  Used to create an instance of a resource on Contentful.

  The function accepts a struct of a valid contentful resource and returns the resource that was created, or an error.

  Note that the `create/1` function is distinct from the `upsert/2` function because you cannot define the `id` of the resource that you are creating. This function will always create a new resource with a automatically generated `id`. If you would like to define the `id` of the resource that you are creating, see the `upsert/2` function.

  ```elixir
  alias Content.ContentManagement.Query
  alias MyApp.BlogPost

  Query.create(%BlogPost{})
  {:ok, %BlogPost{}}
  ```
  """
  def create(resource) do
    url = Resource.base_url(resource, :content_management)

    body =
      Resource.prepare_for_contentful(resource)
      |> Map.delete(:id)
      |> Jason.encode!()

    url
    |> HTTPoison.post(
      body,
      HTTP.headers([:auth, :content_type, :contentful_type], contentful_type: resource.__struct__),
      hackney: [:insecure]
    )
    |> case do
      {:ok, %{body: body}} -> {:ok, process_response!(resource, Jason.decode!(body))}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Used to get a single Contentful resource.

  This is a composable function where the first parameter defined the type of resource that you would like to query and the `id` of that resource.

  ## Examples
  ```elixir
  alias Content.ContentManagement.Query
  alias Content.Resource.ContentType
  alias Content.Resource.Space
  alias MyApp.BlogPost
  alias MyApp.Comment

  Query.get(%BlogPost{}, "the_id_of_my_blog_post")
  Query.get(%Comment{}, "the_id_of_my_comment")
  Query.get(%Space{}, "my_space_id")
  Query.get(%ContentType{}, "my_content_type_id")
  ```

  Note that the Contentful API does not distinguish between different content types when you want to query a `%BlogPost` or a `%Comment{}` for example. Both of these examples make a request to the same endpoint. So if you try to query a `blog_post` but the `id` you provide hits a `comment`, Contentful doesn't care and will return the `comment`. This could of course make debugging rather difficult. For that reason, `Content` checks the content type that has been returned from the api and if it doesn't match, the following response will be returned:

  ```elixir
  {
    :error,
    %Content.Error{
      details: %{
        expected: "comment",
        received: "blog_post",
        response: %{"fields" => %{"content" => %{"en-US" => "asdfasdf"}, "legacy_field" => %{"en-US" => ""}, "rating" => %{"en-US" => nil}, "title" => %{"en-US" => ""}, "views" => %{"en-US" => 123}}, "metadata" => %{"tags" => []}, "sys" => %{"contentType" => %{"sys" => %{"id" => "blog_post", "linkType" => "ContentType", "type" => "Link"}}, "createdAt" => "2022-09-25T18:16:18.350Z", "createdBy" => %{"sys" => %{"id" => "5J5TUlcInAPSw6zfv557d7", "linkType" => "User", "type" => "Link"}}, "environment" => %{"sys" => %{"id" => "integration", "linkType" => "Environment", "type" => "Link"}}, "id" => "1ovcGJESEykRotOaKuTRtE", "publishedCounter" => 0, "space" => %{"sys" => %{"id" => "g8l7lpiniu90", "linkType" => "Space", "type" => "Link"}}, "type" => "Entry", "updatedAt" => "2022-09-25T18:16:18.350Z", "updatedBy" => %{"sys" => %{"id" => "5J5TUlcInAPSw6zfv557d7", "linkType" => "User", "type" => "Link"}}, "version" => 1}}
      },
      type: :content_type_mismatch
    }
  }
  ```
  Notice that the full response from the api has been provided in the error so it's still possible to use whatever is returned.

  In the case that you use `Query.get/2` to query something and you are not sure what is going to be returned, you can use the `Entry` resource type. In this case, an entry of any content type is considered correct.
  ## Examples
  ```elixir
  alias Content.Resource.Entry
  alias MyApp.BlogPost
  alias MyApp.Comment

  Query.get(%Entry{}, "the_id_of_my_blog_post") # will return {:ok, %BlogPost{}}
  Query.get(%Entry{}, "the_id_of_my_comment") # will return {:ok, %Comment{}}
  ```
  """
  def get(resource, id) do
    url = Resource.base_url(resource, :content_management) <> "/#{id}"

    url
    |> HTTPoison.get(HTTP.headers([:auth]), hackney: [:insecure])
    |> case do
      {:ok, %{body: body}} -> process_response!(resource, Jason.decode!(body))
      {:error, error} -> {:error, error}
    end
  end

  def get_all(resource) do
    url = Resource.base_url(resource, :content_management)

    url
    |> HTTPoison.get(HTTP.headers([:auth]), hackney: [:insecure])
    |> case do
      {:ok, %{body: body}} -> process_response!(resource, Jason.decode!(body))
      {:error, error} -> {:error, error}
    end
  end

  def delete(resource, id, version: version) do
    url = Resource.base_url(resource, :content_management) <> "/#{id}"

    url
    |> HTTPoison.delete(HTTP.headers([:auth, :version], version: version), hackney: [:insecure])
    |> case do
      {:ok, %{status_code: 204}} -> :ok
      {:ok, %{body: body}} -> process_response!(resource, Jason.decode!(body))
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Used to upsert an instance of a resource on Contentful.

  The function accepts a struct of a valid contentful resource and returns the resource that was created, or an error.

  Note that the srtuct passed to `upsert/2` must have a non `nil` id to identify the entry that is to be upserted. If an entry exists with that id and the version provided matches the version on Contentfu, the entry will be updated. If no extry exists with that id, a new one will be created.

  You may also provide the `force` option to force an update. In the case of a forced update, two api calls are made. The first to `get` the entry that is being updated and identify the current version, and the second to make the update. Therefore it should be noted that `force` is a feature of this library rather than one provided by Contentful.

  ```elixir
  alias Content.ContentManagement.Query
  alias MyApp.BlogPost

  Query.upsert(%BlogPost{}, "entry_id")
  {:ok, %BlogPost{}} # If nothing eixists with that id a new entry is created

  Query.upsert(%BlogPost{}, "entry_id")
  {:error, :version_mismatch} # As an entry exists a version number must be provided

  Query.upsert(%BlogPost{}, "enrty_id",  version: 1)
  {:ok, %BlogPost{}} # The version provided matches the version on Contentful -> :ok

  Query.upsert(%BlogPost{}, "enrty_id", force: true)
  {:ok, %BlogPost{}} # Version is not checked and entry is force updated
  ```
  """
  def upsert(resource, id, opts \\ []) do
    url = Resource.base_url(resource, :content_management) <> "/#{id}"

    body =
      Resource.prepare_for_contentful(resource)
      |> Map.delete(:id)
      |> Jason.encode!()

    url
    |> HTTPoison.put(
      body,
      HTTP.headers([:auth, :content_type, :contentful_type, :version],
        contentful_type: resource.__struct__,
        version: opts[:version]
      ),
      hackney: [:insecure]
    )
    |> case do
      {:ok, %{body: body}} -> process_response!(resource, Jason.decode!(body))
      {:error, error} -> {:error, error}
    end
  end

  defp process_response!(
         _expected_type,
         %{"sys" => %{"id" => "VersionMismatch"}} = body
       ) do
    %Error{
      type: :version_mismatch,
      details: %{
        response: body
      }
    }
  end

  defp process_response!(
         _expected_type,
         %{"sys" => %{"id" => "NotFound", "type" => "Error"}} = body
       ) do
    %Error{
      type: :resource_not_found,
      details: %{
        response: body
      }
    }
  end

  defp process_response!(
         expected_type,
         %{"items" => items}
       ) do
    {:ok, Enum.map(items, &process_response!(expected_type, &1))}
  end

  defp process_response!(
         %Entry{},
         %{"sys" => %{"contentType" => %{"sys" => %{"id" => content_type_id}}, "type" => "Entry"}} =
           body
       ) do
    Content.content_types()
    |> Enum.find(fn content_type -> content_type.__contentful_schema__.id == content_type_id end)
    |> case do
      nil -> Entry.build_from_response(body)
      content_type -> content_type.build_from_response(body)
    end
  end

  defp process_response!(
         expected_type,
         %{"sys" => %{"contentType" => %{"sys" => %{"id" => content_type_id}}, "type" => "Entry"}} =
           body
       ) do
    if expected_type.__struct__.__contentful_schema__.id == content_type_id do
      expected_type.__struct__.build_from_response(body)
    else
      %Error{
        type: :content_type_mismatch,
        details: %{
          expected: expected_type.__struct__.__contentful_schema__.id,
          received: content_type_id,
          response: body
        }
      }
    end
  end

  defp process_response!(
         _expected_type,
         %{"sys" => %{"type" => "ContentType"}} = body
       ) do
    ContentType.build_from_response(body)
  end
end
