defmodule Content.Field.RichText.Node.Text do
  @moduledoc """
  Text node is the lowest level...
  """

  defstruct [:data, :value, :marks, node_type: "text"]

  defimpl Content.Field.RichText.Node do
    def validate(node) do
      node
    end
  end
end
