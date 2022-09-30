defmodule Content.Resource.Space do
  defstruct [:id, :sys]

  @type t :: %Content.Resource.Space{
          id: String.t(),
          sys: map(),
        }

  defimpl Content.Resource do
    def base_url(_content_type, :content_management) do
      Content.ContentManagement.url() <> "/spaces"
    end
  end
end
