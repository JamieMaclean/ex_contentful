defmodule Content.Entry do
  alias Content.Field

  def to_contentful_entry(entry) do
    fields =
      Map.from_struct(entry)
      |> Map.delete(:id)
      |> Map.delete(:metadata)
      |> Map.delete(:sys)
      |> Map.delete(:__struct__)
      |> Map.keys()
      |> Enum.map(&Field.to_contentful_entry(entry, &1))
      |> Enum.into(%{})

    %{fields: fields}
  end
end
