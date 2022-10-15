defmodule Content.Field.RichText.Node.Paragraph do
  alias __MODULE__
  alias Content.Field.RichText.ValidationError
  alias Content.Field.RichText.Node.Constraints

  @moduledoc """
  TODO
  """

  @derive Jason.Encoder
  defstruct data: %{}, content: [], node_type: Constraints.blocks().paragraph

  defimpl Content.Field.RichText.Node do
    alias Content.Field.RichText.Node

    @valid_nodes ["text" | Map.values(Constraints.inlines())]

    def prepare_for_contentful(node) do
      %{
        "data" => node.data,
        "nodeType" => node.node_type,
        "content" => Enum.map(node.content, &Node.prepare_for_contentful(&1))
      }
    end

    def to_html(node) do
      attributes =
        case Application.get_env(:content, :attributes_module) do
          nil -> []
          module -> module.get_attributes(node)
        end

      {"p", attributes, Enum.map(node.content, &Node.to_html(&1))}
    end

    def validate(%Paragraph{content: content} = paragraph) do
      Enum.filter(content, fn
        %{node_type: node_type} when node_type in @valid_nodes -> false
        _ -> true
      end)
      |> case do
        [] ->
          paragraph

        nodes ->
          %ValidationError{
            node: paragraph,
            type: :invalid_content,
            expected: @valid_nodes,
            received: nodes
          }
      end
    end
  end
end
