defmodule ExContentful.HTTP do
  @moduledoc false
  def access_token(:content_management_token),
    do: Application.get_env(:content, :content_management_token)

  def access_token(:content_delivery_token),
    do: Application.get_env(:content, :content_delivery_token)

  def headers(headers, props \\ [])

  def headers([:auth | tail], props),
    do: [
      {"Authorization", "Bearer #{access_token(:content_management_token)}"}
      | headers(tail, props)
    ]

  def headers([:content_type | tail], props),
    do: [
      {"Content-Type", "application/vnd.contentful.management.v1+json"}
      | headers(tail, props)
    ]

  def headers([:contentful_type | tail], props),
    do: [
      {"X-Contentful-Content-Type", props[:contentful_type].__contentful_schema__.id}
      | headers(tail, props)
    ]

  def headers([:version | tail], props),
    do: [
      {"X-Contentful-Version", props[:version]}
      | headers(tail, props)
    ]

  def headers([], _props), do: []

  def process_response(response) do
    case response do
      {:ok, %{status_code: 200, body: body}} -> Jason.decode!(body)
      {:ok, %{status_code: 201, body: body}} -> Jason.decode!(body)
    end
  end
end
