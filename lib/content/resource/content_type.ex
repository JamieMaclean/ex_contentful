defmodule Content.Resource.ContentType do
  defstruct [:fields, :sys, :metadata]

  defimpl Content.Resource do
    def base_url(_content_type, :content_management) do
      Content.ContentManagement.url() <> "/content_types"
    end
  end
end
