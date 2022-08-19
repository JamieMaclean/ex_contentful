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
    struct = entry.__struct__

    fields =
      struct.__schema__(:fields)
      |> Enum.map(fn field -> {field, struct.__schema__(:type, field)} end)
      |> Enum.filter(fn {_name, type} ->
        case type do
          {_, Ecto.Embedded, _} -> true
          _ -> false
        end
      end)
      |> Enum.map(fn {name, _} ->
        [_, value_name, _] =
          Atom.to_string(name)
          |> String.split("__")

        field = Map.get(entry, name)
        value = Map.get(entry, String.to_existing_atom(value_name))
        {field.id, %{"en-US" => value}}
      end)
      |> Enum.into(%{})

    %{"fields" => fields}
  end
end
