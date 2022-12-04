defmodule ExContentful.Integration.RichTextAdapter do
  @moduledoc false
  require Phoenix.Component
  import Phoenix.Component

  use ExContentful.RichText.Adapter

  def_html %Paragraph{content: [%Text{value: "Change me to bold"}] = content} do
    {"p", [], [{"b", [], parse_content(content)}]}
    assigns = %{}
    ~H"""
      <div>inside sigil H</div>
    """
  end

  def_html [%Hr{}, %Paragraph{content: content}, %Hr{}] do
    {"h1", [], parse_content(content)}
    assigns = %{}
    ~H"""
      <div>inside sigil H</div>
    """
  end
end
