defmodule ExContentful.Field.RichText do
  @moduledoc false

  alias ExContentful.Field.RichText.Node.Document
  alias ExContentful.Field.RichText.Node.Paragraph
  alias ExContentful.Field.RichText.Node.Text
  alias ExContentful.Field.RichText.Node.Hr
  alias ExContentful.Field.RichText.Node.OrderedList
  alias ExContentful.Field.RichText.Node.UnorderedList
  alias ExContentful.Field.RichText.Node.ListItem

  alias ExContentful.Field.RichText.Node.{
    Heading1,
    Heading2,
    Heading3,
    Heading4,
    Heading5,
    Heading6
  }

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

  @type t :: %ExContentful.Field.Integer{
          id: String.t(),
          available_options: list(String.t()),
          contentful_type: String.t(),
          name: String.t(),
          ecto_type: :integer,
          localized: boolean(),
          required: boolean(),
          omitted: boolean()
        }

  alias ExContentful.Field.RichText.Node
  alias ExContentful.Field.RichText.Node.Document

  def to_html(%Document{content: content}) do
    Node.prepare_for_contentful(content)
  end

  def parse(%{"nodeType" => "document", "data" => data, "content" => content}) do
    %Document{data: data, content: Enum.map(content, &parse(&1))}
  end

  def parse(%{"nodeType" => "paragraph", "data" => data, "content" => content}) do
    %Paragraph{data: data, content: Enum.map(content, &parse(&1))}
  end

  def parse(%{"nodeType" => "ordered-list", "data" => data, "content" => content}) do
    %OrderedList{data: data, content: Enum.map(content, &parse(&1))}
  end

  def parse(%{"nodeType" => "unordered-list", "data" => data, "content" => content}) do
    %UnorderedList{data: data, content: Enum.map(content, &parse(&1))}
  end

  def parse(%{"nodeType" => "list-item", "data" => data, "content" => content}) do
    %ListItem{data: data, content: Enum.map(content, &parse(&1))}
  end

  def parse(%{"nodeType" => "heading-1", "data" => data, "content" => content}) do
    %Heading1{data: data, content: Enum.map(content, &parse(&1))}
  end

  def parse(%{"nodeType" => "heading-2", "data" => data, "content" => content}) do
    %Heading2{data: data, content: Enum.map(content, &parse(&1))}
  end

  def parse(%{"nodeType" => "heading-3", "data" => data, "content" => content}) do
    %Heading3{data: data, content: Enum.map(content, &parse(&1))}
  end

  def parse(%{"nodeType" => "heading-4", "data" => data, "content" => content}) do
    %Heading4{data: data, content: Enum.map(content, &parse(&1))}
  end

  def parse(%{"nodeType" => "heading-5", "data" => data, "content" => content}) do
    %Heading5{data: data, content: Enum.map(content, &parse(&1))}
  end

  def parse(%{"nodeType" => "heading-6", "data" => data, "content" => content}) do
    %Heading6{data: data, content: Enum.map(content, &parse(&1))}
  end

  def parse(%{"nodeType" => "hr", "data" => data, "content" => content}) do
    %Hr{data: data, content: Enum.map(content, &parse(&1))}
  end

  def parse(%{"nodeType" => "text", "data" => data, "value" => value, "marks" => marks}) do
    %Text{marks: convert_marks(marks), data: data, value: value}
  end

  def convert_marks(marks) do
    Enum.map(marks, fn %{"type" => type} -> %{type: type} end)
  end
end
