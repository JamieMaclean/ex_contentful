defmodule Content.Field do
  def to_contentful_entry(parent, field_name) do
    schema = parent.__struct__.contentful_schema
    {Map.get(schema.fields, field_name).id, %{"en-US" => Map.get(parent, field_name)}}
  end

  def to_contentful_schema(%{cardinality: cardinality} = field_props) do
    case cardinality do
      :one -> map_to_single_embed(field_props)
      :many -> map_to_array_embed(field_props)
    end
  end

  defp map_to_single_embed(field_props) do
    field_props
    |> Map.put(:type, Map.get(field_props, :contentful_type))
    |> Map.delete(:contentful_type)
    |> Map.delete(:cardinality)
  end

  defp map_to_array_embed(field_props) do
    map_to_single_embed(field_props)
    |> Map.delete(:required)
    |> Map.delete(:localized)
    |> Map.put(:items, %{type: Map.get(field_props, :contentful_type)})
    |> Map.put(:type, "Array")
  end
end
