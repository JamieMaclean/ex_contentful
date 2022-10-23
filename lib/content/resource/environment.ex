defmodule Content.Resource.Environment do
  @moduledoc """
  Environment is one of the Contentful base resources. This struct can be used in conjunction with any of the `Query` modules to access and update any of your Environments in Contentful
  """
  defstruct [:id, :sys]

  @type t :: %Content.Resource.Environment{
          id: String.t(),
          sys: map()
        }

  defimpl Content.Resource do
    def base_url(_content_type, :content_management) do
      Content.ContentManagement.url() <> "/environments"
    end

    def prepare_for_contentful(_content_type) do
      raise "Not implemented"
    end
  end
end
