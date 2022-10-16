defmodule Content.HTMLAttributes do
  @moduledoc false

  @callback get_attributes(node :: term()) :: list()

  defmacro __before_compile__(_env) do
    quote do
      def get_attributes(_), do: []
    end
  end

  defmacro __using__([]) do
    quote do
      @behaviour Content.HTMLAttributes

      @before_compile Content.HTMLAttributes
    end
  end
end
