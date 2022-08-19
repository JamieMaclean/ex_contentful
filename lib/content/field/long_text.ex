defmodule Content.Field.LongText do
  defstruct [
    :cardinality,
    :name,
    id: "",
    localized: false,
    required: false,
    type: :string,
    contentful_type: "Text",
    omitted: false
  ]
end
