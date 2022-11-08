defmodule Content.ContentDelivery do
  @base_url "https://cdn.contentful.com"

  @moduledoc """
  This module can be used to access Contentful's Content Management API.

  This module provides some basic, composable functions that can be used to query any Contentful resource
  """

  alias Content.Config
  alias Content.Error
  alias Content.HTTP
  alias Content.Resource
  alias Content.Resource.ContentType
  alias Content.Resource.Entry
  alias Content.Resource.ContentType

  def url,
    do: "#{@base_url}/spaces/#{Config.space_id()}"

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
    url =
      Resource.base_url(resource, :content_delivery) <>
        "/#{id}?access_token=#{HTTP.access_token(:content_delivery_token)}"

    url
    |> HTTPoison.get([], hackney: [:insecure])
    |> case do
      {:ok, %{body: body}} -> process_response!(resource, Jason.decode!(body))
      {:error, error} -> {:error, error}
    end
  end

  def get_all(resource) do
    url = Resource.base_url(resource, :content_delivery)

    url
    |> HTTPoison.get(HTTP.headers([:auth]), hackney: [:insecure])
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
    Config.content_types()
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
      expected_type.__struct__.build_from_response(body, :content_delivery_api)
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
