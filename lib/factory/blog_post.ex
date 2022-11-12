defmodule ExContentful.Factory.BlogPost do
  @moduledoc false

  alias ExContentful.Integration.BlogPost
  alias ExContentful.Factory.RichText

  def build(node, args \\ %{})

  def build(:blog_post, args) do
    struct(
      %BlogPost{},
      Map.merge(
        %{
          content: RichText.build(:full_document),
          views: 123
        },
        args
      )
    )
  end
end
