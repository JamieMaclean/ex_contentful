defmodule ExContentful.Field.RichText.Node.Hr do
  alias __MODULE__
  alias ExContentful.Field.RichText.ValidationError
  alias ExContentful.Field.RichText.Node.Constraints

  @moduledoc """
  TODO
  """

  defstruct data: %{}, content: [], node_type: Constraints.blocks_mapping().hr

  defimpl ExContentful.Field.RichText.Node do
    def to_html(_node), do: "<p>Hello</p>"

    def prepare_for_contentful(node) do
      %{
        "data" => node.data,
        "nodeType" => node.node_type,
        "content" => []
      }
    end

    def validate(%Hr{content: content} = node) do
      if Enum.empty?(content) do
        node
      else
        %ValidationError{
          node: node,
          type: :invalid_content,
          expected: [],
          received: content
        }
      end
    end
  end
end
