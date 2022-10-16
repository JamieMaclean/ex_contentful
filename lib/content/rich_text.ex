defprotocol Content.RichText do
  @moduledoc false

  def to_html(node, data \\ nil)
end
