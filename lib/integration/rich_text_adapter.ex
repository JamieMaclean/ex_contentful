defmodule Content.Integration.RichTextAdapter do
  @moduledoc false

  use Content.RichText.Adapter

  def_html %Paragraph{content: [%Text{value: "Change me to bold"}] = content} do
    {"p", [], [{"b", [], parse_content(content)}]}
  end

  def_html [%Hr{}, %Paragraph{content: content}, %Hr{}] do
    {"h1", [], parse_content(content)}
  end
end
