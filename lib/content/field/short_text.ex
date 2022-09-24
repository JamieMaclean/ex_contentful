defmodule Content.Field.ShortText do
  defstruct [
    :name,
    id: "",
    available_options: [],
    localized: false,
    required: false,
    contentful_type: "Symbol",
    ecto_type: :string,
    omitted: false
  ]

  @type t :: %Content.Field.ShortText{
          id: String.t(),
          contentful_type: String.t(),
          name: String.t(),
          ecto_type: :string,
          localized: boolean(),
          required: boolean(),
          omitted: boolean()
        }
end
