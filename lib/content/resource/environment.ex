defmodule Content.Resource.Environment do
  defstruct [:id, :sys]

  defimpl Content.Resource do
    def base_url(_content_type, :content_management) do
      Content.ContentManagement.url() <> "/environments"
    end
  end
end
