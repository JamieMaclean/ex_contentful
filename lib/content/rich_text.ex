defmodule Content.RichText do
  @moduledoc false

  defmacro __before_compile__(_) do
    quote do
      alias Content.Field.RichText.Node.{Document, Paragraph, Text, Blockquote}

      def to_html(node, data \\ nil)

      def to_html(%Document{} = node, data) do
        Enum.map(node.content, &to_html(&1, data))
        |> Floki.raw_html()
      end

      def to_html(%Paragraph{} = node, data) do
        attributes =
          case Application.get_env(:content, :attributes_module) do
            nil -> []
            module -> module.get_attributes(node)
          end

        {"p", attributes, Enum.map(node.content, &to_html(&1, data))}
      end

      def to_html(%Blockquote{} = node, data) do
        attributes =
          case Application.get_env(:content, :attributes_module) do
            nil -> []
            module -> module.get_attributes(node)
          end

        {"blockquote", attributes, Enum.map(node.content, &to_html(&1, data))}
      end

      def to_html(%Text{marks: [], value: value}, _), do: value
      def to_html(%Text{marks: marks, value: value}, _), do: wrap_with_marks(marks, value)

      def get_attributes(%Paragraph{content: [%Text{}, %Blockquote{}]}) do
        [
          {"class", "aClass"}
        ]
      end

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
    end
  end

  defmacro __using__(_) do
    quote do
      @before_compile Content.RichText
    end
  end
end
