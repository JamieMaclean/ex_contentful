defmodule Content.Field.Number do
  @moduledoc false

  defstruct [
    :name,
    id: "",
    available_options: [],
    localized: false,
    required: false,
    contentful_type: "Number",
    ecto_type: :float,
    omitted: false
  ]

  @type t :: %Content.Field.Number{
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
