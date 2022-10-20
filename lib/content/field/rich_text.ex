defmodule Content.Field.RichText do
  @moduledoc false

  defstruct [
    :name,
    id: "",
    available_options: [],
    localized: false,
    required: false,
    contentful_type: "RichText",
    ecto_type: :map,
    omitted: false
  ]

  @type t :: %Content.Field.Integer{
          id: String.t(),
          available_options: list(String.t()),
          contentful_type: String.t(),
          name: String.t(),
          ecto_type: :integer,
          localized: boolean(),
          required: boolean(),
          omitted: boolean()
        }

  alias Content.Field.RichText.Node
  alias Content.Field.RichText.Node.Document

  def to_html(%Document{content: content}) do
    Node.prepare_for_contentful(content)
  end
end
