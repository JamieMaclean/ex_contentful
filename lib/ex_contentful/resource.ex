defprotocol ExContentful.Resource do
  @moduledoc false
  def base_url(resource, api)

  def prepare_for_contentful(resource)
end
