defmodule Content.Schema.FieldArray do
  @moduledoc false

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
