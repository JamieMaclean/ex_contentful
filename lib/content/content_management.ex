defmodule Content.ContentManagement do
  @base_url "https://api.contentful.com"

  def url,
    do: "#{@base_url}/spaces/#{Content.space_id()}/environments/#{Content.environment_id()}"
end
