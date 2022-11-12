defmodule ExContentful.Resource.Environment do
  @moduledoc """
  Environment is one of the Contentful base resources. This struct can be used in conjunction with any of the `Query` modules to access and update any of your Environments in Contentful
  """
  defstruct [:id, :sys]

  @type t :: %ExContentful.Resource.Environment{
          id: String.t(),
          sys: map()
        }

  defimpl ExContentful.Resource do
    def base_url(_content_type, :content_management) do
      ExContentful.ContentManagement.url() <> "/environments"
    end

    def prepare_for_contentful(_content_type) do
      raise "Not implemented"
    end
  end
end
