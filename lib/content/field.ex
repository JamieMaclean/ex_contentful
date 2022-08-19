defmodule Content.Field do
  def to_contentful_entry(parent, field_name) do
    string_field_name = Atom.to_string(field_name)
    props_field_name = String.to_existing_atom("__" <> string_field_name <> "__")

    props = Map.get(parent, props_field_name)
    {Map.get(props, :id), %{"en-US" => Map.get(parent, field_name)}}
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
