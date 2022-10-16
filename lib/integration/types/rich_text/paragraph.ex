defimpl Content.RichText, for: Content.RichText.Node.Paragraph do
  def to_html(%{content: []}) do
    "Custom impl"
  end
end
