defmodule Content.Field.RichText do
  @moduledoc false

  alias Content.Field.RichText.Node.Document
  alias Content.Field.RichText.Node.Paragraph
  alias Content.Field.RichText.Node.Text

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

  def parse(%{"nodeType" => "document", "data" => data, "content" => content}) do
    %Document{data: data, content: Enum.map(content, &parse(&1))}
  end

  def parse(%{"nodeType" => "paragraph", "data" => data, "content" => content}) do
    %Paragraph{data: data, content: Enum.map(content, &parse(&1))}
  end

  def parse(%{"nodeType" => "text", "data" => data, "value" => value, "marks" => marks}) do
    %Text{marks: marks, data: data, value: value}
  end
end
