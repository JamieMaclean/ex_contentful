defmodule Content.Integration.RichTextAdapter do
  @moduledoc false

  use Content.RichText.Adapter

  html_block [%Paragraph{content: [%Text{value: "matched bold text"}] = content}] do
    {"p", [], [{"bold", [], parse_content(content)}]}
  end

  html_block [%Paragraph{content: content}] do
    {"p", [], parse_content(content)}
  end
end
