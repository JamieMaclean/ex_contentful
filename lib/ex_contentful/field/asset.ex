defmodule ExContentful.Field.Asset do
  @moduledoc false

  defstruct [
    :name,
    id: "",
    available_options: [],
    localized: false,
    required: false,
    contentful_type: "Asset",
    ecto_type: :string,
    omitted: false
  ]

  @type t :: %ExContentful.Field.Asset{
          id: String.t(),
          available_options: list(String.t()),
          contentful_type: String.t(),
          name: String.t(),
          ecto_type: :string,
          localized: boolean(),
          required: boolean(),
          omitted: boolean()
        }
end
