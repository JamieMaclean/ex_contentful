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

    def to_html(%{marks: [], value: value}), do: value
    def to_html(%{marks: marks, value: value}), do: wrap_with_marks(marks, value)

    defp wrap_with_marks([], value), do: value

    defp wrap_with_marks([%{type: mark} | rest], value) do
      {open, close} = mark_to_tag(mark)
      wrapped_value = open <> value <> close
      wrap_with_marks(rest, wrapped_value)
    end

    defp mark_to_tag("bold"), do: {"<b>", "</b>"}
    defp mark_to_tag("italic"), do: {"<em>", "</em>"}
    defp mark_to_tag("underline"), do: {"<u>", "</u>"}
    defp mark_to_tag("code"), do: {"<code>", "</code>"}

    defp valid_mark?(%{type: type}) when type in @valid_marks, do: true
    defp valid_mark?(_), do: false
  end
end
