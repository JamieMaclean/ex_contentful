defmodule ExContentful.Schema.Field do
  @moduledoc false

  defstruct [
    :name,
    :type,
    id: "",
    localized: false,
    required: false,
    omitted: false
  ]

  @type t :: %ExContentful.Schema.Field{
          name: String.t(),
          type: String.t(),
          id: String.t(),
          localized: boolean(),
          required: boolean(),
          omitted: boolean()
        }

  alias ExContentful.Field.RichText.Node
  alias ExContentful.Field.RichText.Node.Document

  def prepare_for_contentful(parent, field_name) do
    value =
      case Map.get(parent, field_name) do
        %Document{} = node -> Node.prepare_for_contentful(node)
        other -> other
      end

    schema = parent.__struct__.__contentful_schema__
    field = Enum.find(schema.fields, fn field -> field.id == Atom.to_string(field_name) end)
    {field.id, %{"en-US" => value}}
  end
end
