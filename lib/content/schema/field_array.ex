defmodule Content.Schema.FieldArray do
  defstruct [
    :name,
    type: "Array",
    id: "",
    items: %{
      type: "",
      validations: []
    },
    localized: false,
    required: false,
    omitted: false
  ]
end
