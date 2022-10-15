defmodule Content.Field.RichText.Node.Blockquote do
  alias __MODULE__
  alias Content.Field.RichText.ValidationError
  alias Content.Field.RichText.Node.Constraints

  @moduledoc """
  TODO
  """

  defstruct [:data, :content, node_type: Constraints.blocks().blockquote]

  defimpl Content.Field.RichText.Node do
    alias Content.Field.RichText.Node
    @valid_nodes [Constraints.blocks().paragraph]

    def to_html(node) do
      attributes =
        case Application.get_env(:content, :attributes_module) do
          nil -> []
          module -> module.get_attributes(node)
        end

      {"blockquote", attributes, Enum.map(node.content, &Node.to_html(&1))}
    end

    def validate(%Blockquote{content: content} = node) do
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
