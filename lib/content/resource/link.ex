defmodule Content.Resource.Link do
  @moduledoc """
  Link is one of the Contentful base resources. This struct can be used in conjunction with any of the `Query` modules to access and update any of your Links in Contentful
  """
  defstruct id: "",
            link_type: "",
            type: ""

  @type t :: %Content.Resource.Link{
          id: String.t(),
          link_type: String.t(),
          type: String.t()
        }
end
