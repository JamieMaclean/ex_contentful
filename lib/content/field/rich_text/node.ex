defprotocol Content.Field.RichText.Node do
  @moduledoc """
  A useful description of nodes

  Explain how this protocol can be extended to match to match and convert data
  """

  def validate(node)
  def to_html(node, data \\ nil)
  def prepare_for_contentful(node)
end
