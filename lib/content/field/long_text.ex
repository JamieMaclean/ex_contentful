defmodule Content.Field.LongText do
  defstruct [
    :name,
    id: "",
    localized: false,
    required: false,
    type: :string,
    contentful_type: "Text",
    ecto_type: :string,
    omitted: false
  ]

  @type t :: %Content.Field.LongText{
    id: String.t(),
    contentful_type: String.t(),
    name: String.t(),
    ecto_type: :text,
    localized: boolean(),
    required: boolean(),
    omitted: boolean(),
  }
end
