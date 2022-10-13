defmodule Content.Field.RichText.Node.OrderedList do
  alias __MODULE__
  alias Content.Field.RichText.ValidationError
  alias Content.Field.RichText.Node.Constraints

  @moduledoc """
  TODO
  """

  defstruct [:data, :content, node_type: Constraints.blocks().ordered_list]

  defimpl Content.Field.RichText.Node do
    @valid_nodes [Constraints.blocks().list_item]

    def validate(%OrderedList{content: content} = node) do
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
            valid_node_types: @valid_nodes,
            recieved: nodes
          }
      end
    end
  end
end
