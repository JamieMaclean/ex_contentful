defmodule Content.Entry do
  alias Content.Field

  defp is_prop?(key) do
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
