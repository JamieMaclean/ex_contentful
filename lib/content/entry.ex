defmodule Content.Entry do
  alias Content.Field

  def to_contentful_entry(entry) do
    fields =
      Map.from_struct(entry)
      |> Map.delete(:__struct__)
      |> Map.keys()
      |> Enum.map(&Field.to_contentful_entry(entry, &1))
      |> Enum.into(%{})

    %{fields: fields}
  end

  def all(application) do
    {:ok, modules} = :application.get_key(application, :modules)

    modules
    |> Enum.filter(&({:__contentful_schema__, 0} in &1.__info__(:functions)))
    |> IO.inspect()
  end
end
