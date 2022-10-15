defmodule Content.Factory.BlogPost do
  alias Content.Integration.BlogPost
  alias Content.Factory.RichText

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
