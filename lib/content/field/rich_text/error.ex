defmodule Content.Field.RichText.ValidationError do
  @moduledoc """
  Explain the different error types
  """

  defstruct [:node, :type, :recieved, :valid_node_types]
end
