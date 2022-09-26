defmodule Content.Resource.Link do
  defstruct id: "",
            link_type: "",
            type: ""

  @type t :: %Content.Resource.Link{
          id: String.t(),
          link_type: String.t(),
          type: String.t()
        }
end
