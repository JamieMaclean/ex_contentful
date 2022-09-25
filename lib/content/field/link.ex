defmodule Content.Field.Link do
  defstruct id: "",
            link_type: "",
            type: ""

  @type t :: %Content.Field.Link{
          id: String.t(),
          link_type: String.t(),
          type: String.t()
        }
end
