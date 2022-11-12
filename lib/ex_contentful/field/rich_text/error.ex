defmodule ExContentful.Field.RichText.ValidationError do
  @moduledoc """
  Explain the different error types
  """

  defstruct [:node, :type, :received, :expected]
end
