defmodule Content.Field do
  def to_contentful_entry(parent, field_name) do
    schema = parent.__struct__.contentful_schema
    {Map.get(schema.fields, field_name).id, %{"en-US" => Map.get(parent, field_name)}}
  end
end
