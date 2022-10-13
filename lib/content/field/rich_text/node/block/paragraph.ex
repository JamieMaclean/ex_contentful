defmodule Content.Field.RichText.Node.Paragraph do
  alias __MODULE__
  alias Content.Field.RichText.ValidationError
  alias Content.Field.RichText.Node.Constraints

  @moduledoc """
  TODO
  """

  defstruct [:data, :content, node_type: Constraints.blocks().paragraph]

  defimpl Content.Field.RichText.Node do
    @valid_nodes ["text" | Map.values(Constraints.inlines())]

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
