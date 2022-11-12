defmodule ExContentful.Field.LongText do
  @moduledoc false

  defstruct [
    :name,
    id: "",
    available_options: [],
    localized: false,
    required: false,
    type: :string,
    contentful_type: "Text",
    ecto_type: :string,
    omitted: false
  ]

  @type t :: %ExContentful.Field.LongText{
          id: String.t(),
          contentful_type: String.t(),
          name: String.t(),
          ecto_type: :text,
          localized: boolean(),
          required: boolean(),
          omitted: boolean()
        }
end
