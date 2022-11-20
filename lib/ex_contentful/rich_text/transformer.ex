defmodule ExContentful.RichText.Transformer do
  @moduledoc false

  alias ExContentful.Field.RichText.Node.Custom
  alias ExContentful.Field.RichText.Node.Text

  def transform(%{content: content} = node) do
    content =
      Enum.map(content, &transform(&1))
      |> List.flatten()

    Map.put(node, :content, content)
  end

  def transform(%Text{value: value, marks: marks} = text) do
    if transform_text?(marks) do
      set_text(value)
      |> Enum.map(fn
        text when is_binary(text) -> %Text{marks: marks, value: text}
        other -> other
      end)
    else
      text
    end
  end

  def transform(node), do: node

  defp transform_text?(marks) do
    !Enum.any?(marks, fn
      %{type: "code"} -> true
      _ -> false
    end)
  end

  defp set_text(text) do
    String.split(text, ~r(\n), include_captures: true)
    |> Enum.map(fn
      "\n" -> %Custom{node_type: "br"}
      other -> other
    end)
  end
end
