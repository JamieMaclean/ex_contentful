defmodule Content.Resource.Entry do
  @moduledoc """
  Entry is one of the Contentful base resources. This struct can be used in conjunction with any of the `Query` modules to access and update any of your Entries in Contentful
  """
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
