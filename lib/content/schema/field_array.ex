defmodule Content.Schema.FieldArray do
  defstruct [
    :name,
    type: "Array",
    id: "",
    available_options: [],
    items: %{
      type: "",
      validations: []
    },
    localized: false,
    required: false,
    omitted: false
  ]
end
