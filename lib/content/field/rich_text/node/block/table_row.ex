defmodule Content.Field.RichText.Node.TableRow do
  alias __MODULE__
  alias Content.Field.RichText.ValidationError
  alias Content.Field.RichText.Node.Constraints

  @moduledoc """
  TODO
  """

  defstruct [:data, :content, node_type: Constraints.blocks().table_row]

  defimpl Content.Field.RichText.Node do
    @valid_nodes [Constraints.blocks().table_cell, Constraints.blocks().table_header_cell]

    def to_html(_node), do: "<p>Hello</p>"

    def validate(%TableRow{content: content} = node) do
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
