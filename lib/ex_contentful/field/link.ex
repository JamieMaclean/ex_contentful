defmodule ExContentful.Field.Link do
  @moduledoc false

  defstruct [
    :name,
    id: "",
    available_options: [],
    localized: false,
    required: false,
    contentful_type: "Link",
    ecto_type: :float,
    omitted: false
  ]

  @type t :: %ExContentful.Field.Link{
          id: String.t(),
          available_options: list(String.t()),
          contentful_type: String.t(),
          name: String.t(),
          ecto_type: :float,
          localized: boolean(),
          required: boolean(),
          omitted: boolean()
        }
end
