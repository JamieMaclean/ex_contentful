defmodule Content.Resource.Entry do
  defstruct [:entry, :sys, :metadata]

  @type t :: %Content.Resource.Entry{
    entry: struct(),
    sys: map(),
    metadata: map()
  }

  defimpl Content.Resource do
    def base_url(_content_type, :content_management) do
      Content.ContentManagement.url() <> "/entries"
    end
  end
end
