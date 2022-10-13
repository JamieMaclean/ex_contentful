defmodule Content.Field.RichText.Node.Inline do
  alias __MODULE__
  alias Content.Field.RichText.Node.Text

  @moduledoc """
  The types of Block Nodes are:

  - X
  - Y
  - Z
  """

  defstruct [:node_type, :data, :content]

  @type t :: %Content.Field.RichText.Node.Inline{
          node_type: String.t(),
          data: map(),
          content: list(Inline.t() | Text.t())
        }

  defimpl Content.Field.RichText.Node do
    @inline_node_types [
      "hyperlink",
      "entry-hyperlink",
      "asset-hyperlink",
      "embedded-entry-inline"
    ]

    def validate(%Inline{node_type: node_type} = node) when node_type in @inline_node_types do
      node
    end

    def validate(_node) do
      raise "invalid node type"
    end
  end
end
