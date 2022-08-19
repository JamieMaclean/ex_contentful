defmodule Content.Entry do
  alias Content.Field

  def to_contentful_schema(entry) do
    fields =
      Map.keys(entry)
      |> Enum.filter(fn key -> is_prop?(key) end)
      |> List.delete(:__id__)
      |> List.delete(:__name__)
      |> List.delete(:__struct__)
      |> Enum.map(&Field.to_contentful_schema(Map.get(entry, &1)))

    %{
      name: Map.get(entry, :__name__),
      fields: fields
    }
  end

  def is_prop?(key) do
    key = Atom.to_string(key)

    if String.starts_with?(key, "__") && String.ends_with?(key, "__") do
      true
    else
      false
    end
  end

  def to_contentful_entry(entry) do
    fields =
      Map.keys(entry)
      |> Enum.filter(fn key -> !is_prop?(key) end)
      |> Enum.map(&Field.to_contentful_entry(entry, &1))
      |> Enum.into(%{})

    %{fields: fields}
  end
end
