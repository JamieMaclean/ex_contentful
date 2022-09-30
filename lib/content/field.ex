defmodule Content.Field do
  @moduledoc false

  @type t :: :short_text | :long_text

  def to_contentful_entry(parent, field_name) do
    schema = parent.__struct__.__contentful_schema__
    field = Enum.find(schema.fields, fn field -> field.id == Atom.to_string(field_name) end)
    {field.id, %{"en-US" => Map.get(parent, field_name)}}
  end
end
