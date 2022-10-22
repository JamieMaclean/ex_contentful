defmodule Content.Field.RichText.Node.Text do
  @moduledoc """
  Text node is the lowest level...
  """

  @derive Jason.Encoder
  defstruct data: %{}, value: "", marks: [], node_type: "text"

  alias __MODULE__
  alias Content.Field.RichText.Node.Constraints
  alias Content.Field.RichText.ValidationError

  defimpl Content.Field.RichText.Node do
    @valid_marks Map.values(Constraints.marks())

    def prepare_for_contentful(node) do
      %{
        "data" => node.data,
        "nodeType" => node.node_type,
        "value" => node.value,
        "marks" => node.marks
      }
    end

    def validate(%Text{value: value} = node) when not is_binary(value) do
      %ValidationError{
        node: node,
        type: :invalid_value,
        expected: "binary",
        received: value
      }
    end

    def validate(%Text{marks: marks} = node) do
      Enum.filter(marks, fn mark -> !valid_mark?(mark) end)
      |> case do
        [] ->
          node

        marks ->
          %ValidationError{
            node: node,
            type: :invalid_mark,
            expected: @valid_marks,
            received: marks
          }
      end
    end

    defp valid_mark?(%{type: type}) when type in @valid_marks, do: true
    defp valid_mark?(_), do: false
  end
end
