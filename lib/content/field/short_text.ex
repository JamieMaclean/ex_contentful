defmodule Content.Field.ShortText do
  defstruct [
    :cardinality,
    :name,
    id: "",
    available_options: [],
    localized: false,
    required: false,
    type: :string,
    contentful_type: "Symbol",
    omitted: false
  ]
end
