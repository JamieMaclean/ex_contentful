defmodule Content.Schema.Field do
  @moduledoc false

  defstruct [
    :name,
    :type,
    id: "",
    localized: false,
    required: false,
    omitted: false
  ]

  @type t :: %Content.Schema.Field{
          name: String.t(),
          type: String.t(),
          id: String.t(),
          localized: boolean(),
          required: boolean(),
          omitted: boolean()
        }

  alias __MODULE__
  alias Content.Field.ShortText
  alias Content.Field.LongText
  alias Jason

  @spec prepare(field :: ShortText.t() | LongText.t()) :: Field.t()
  def prepare(field) do
    Jason.encode!(field)
  end
end
