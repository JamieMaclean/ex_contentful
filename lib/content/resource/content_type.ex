defmodule Content.Resource.ContentType do
  defstruct [:fields, :sys, :metadata]

  @type t :: %Content.Resource.ContentType{
          fields: list(map()),
          sys: map(),
          metadata: map()
        }

  defimpl Content.Resource do
    def base_url(_content_type, :content_management) do
      Content.ContentManagement.url() <> "/content_types"
    end
  end
end
