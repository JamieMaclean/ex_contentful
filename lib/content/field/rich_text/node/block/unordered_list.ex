defmodule ExContentful.Field.RichText.Node.UnorderedList do
  alias __MODULE__
  alias ExContentful.Field.RichText.ValidationError
  alias ExContentful.Field.RichText.Node.Constraints

  @moduledoc """
  TODO
  """

  defstruct data: %{}, content: [], node_type: Constraints.blocks_mapping().unordered_list

  defimpl ExContentful.Field.RichText.Node do
    alias ExContentful.Field.RichText.Node

    @valid_nodes [Constraints.blocks_mapping().list_item]

    def to_html(_node), do: "<p>Hello</p>"

    def prepare_for_contentful(node) do
      %{
        "data" => node.data,
        "nodeType" => node.node_type,
        "content" => Enum.map(node.content, &Node.prepare_for_contentful(&1))
      }
    end

    def validate(%UnorderedList{content: content} = node) do
      Enum.filter(content, fn
        %{node_type: node_type} when node_type in @valid_nodes -> false
        _ -> true
      end)
      |> case do
        [] ->
          node

        nodes ->
          %ValidationError{
            node: node,
            type: :invalid_content,
            expected: @valid_nodes,
            received: nodes
          }
      end
    end
  end
end
