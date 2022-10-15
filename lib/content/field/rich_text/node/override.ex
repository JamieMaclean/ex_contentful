defprotocol Content.Field.RichText.Node.Override do
  @moduledoc """
  A useful description of nodes

  Explain how this protocol can be extended to match to match and convert data
  """

  def validate(node)
  def to_html(node)
end
