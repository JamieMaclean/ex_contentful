defmodule ExContentful.Factory.ContentfulRichText do
  @moduledoc false

  def build(node, args \\ %{})

  def build(:block, args) do
    %{
      "nodeType" => args["nodeType"],
      "data" => args["data"] || %{},
      "content" => args["content"] || []
    }
  end

  def build(:document, args) do
    args = Map.merge(%{"nodeType" => "document"}, args)
    build(:block, args)
  end

  def build(:hr, args) do
    args = Map.merge(%{"nodeType" => "hr"}, args)
    build(:block, args)
  end

  def build(:paragraph, args) do
    args = Map.merge(%{"nodeType" => "paragraph"}, args)
    build(:block, args)
  end

  def build(:ordered_list, args) do
    args = Map.merge(%{"nodeType" => "ordered-list"}, args)
    build(:block, args)
  end

  def build(:unordered_list, args) do
    args = Map.merge(%{"nodeType" => "unordered-list"}, args)
    build(:block, args)
  end

  def build(:list_item, args) do
    args = Map.merge(%{"nodeType" => "list-item"}, args)
    build(:block, args)
  end

  def build(:heading_1, args) do
    args = Map.merge(%{"nodeType" => "heading-1"}, args)
    build(:block, args)
  end

  def build(:heading_2, args) do
    args = Map.merge(%{"nodeType" => "heading-2"}, args)
    build(:block, args)
  end

  def build(:heading_3, args) do
    args = Map.merge(%{"nodeType" => "heading-3"}, args)
    build(:block, args)
  end

  def build(:heading_4, args) do
    args = Map.merge(%{"nodeType" => "heading-4"}, args)
    build(:block, args)
  end

  def build(:heading_5, args) do
    args = Map.merge(%{"nodeType" => "heading-5"}, args)
    build(:block, args)
  end

  def build(:heading_6, args) do
    args = Map.merge(%{"nodeType" => "heading-6"}, args)
    build(:block, args)
  end

  def build(:text, args) do
    Map.merge(
      %{
        "nodeType" => "text",
        "marks" => [],
        "value" => "Hello world!",
        "data" => %{}
      },
      args
    )
  end
end
