defmodule Content.Schema.Field do
  @moduledoc false

  defstruct [
    :name,
    :type,
    id: "",
    localized: false,
    required: false,
    omitted: false
  ]

  @type t :: %Content.Schema.Field{
          name: String.t(),
          type: String.t(),
          id: String.t(),
          localized: boolean(),
          required: boolean(),
          omitted: boolean()
        }

  def prepare_for_contentful(parent, field_name) do
    schema = parent.__struct__.__contentful_schema__
    field = Enum.find(schema.fields, fn field -> field.id == Atom.to_string(field_name) end)
    {field.id, %{"en-US" => Map.get(parent, field_name)}}
  end
end
