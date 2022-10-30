defmodule Content.Field.RichText.Node.Constraints do
  @moduledoc """
  Explain constraints
  """

  # Functions in this module are only ever called at compile-time. It is therefore
  # not relevant whether or not they are covered.
  #
  # coveralls-ignore-start
  def blocks_mapping,
    do: %{
      document: "document",
      paragraph: "paragraph",
      heading_1: "heading-1",
      heading_2: "heading-2",
      heading_3: "heading-3",
      heading_4: "heading-4",
      heading_5: "heading-5",
      heading_6: "heading-6",
      ordered_list: "ordered-list",
      unordered_list: "unordered-list",
      list_item: "list-item",
      hr: "hr",
      blockquote: "blockquote",
      embedded_entry: "embedded-entry-block",
      embedded_asset: "embedded-asset-block",
      table: "table",
      table_row: "table-row",
      table_cell: "table-cell",
      table_header_cell: "table-header-cell"
    }

  def blocks, do: Map.values(blocks_mapping())

  def inlines_mapping,
    do: %{
      hyperlink: "hyperlink",
      entry_hyperlink: "entry-hyperlink",
      asset_hyperlink: "asset-hyperlink",
      inline_entry: "embedded-entry-inline"
    }

  def inlines, do: Map.values(inlines_mapping())

  def marks,
    do: %{
      bold: "bold",
      italic: "italic",
      underline: "underline",
      code: "code"
    }

  def top_level_blocks do
    blocks = blocks_mapping()

    [
      blocks.paragraph,
      blocks.heading_1,
      blocks.heading_2,
      blocks.heading_3,
      blocks.heading_4,
      blocks.heading_5,
      blocks.heading_6,
      blocks.ordered_list,
      blocks.unordered_list,
      blocks.hr,
      blocks.blockquote,
      blocks.embedded_entry,
      blocks.embedded_asset,
      blocks.table
    ]
  end

  def list_item_blocks do
    blocks = blocks_mapping()

    [
      blocks.paragraph,
      blocks.heading_1,
      blocks.heading_2,
      blocks.heading_3,
      blocks.heading_4,
      blocks.heading_5,
      blocks.heading_6,
      blocks.ordered_list,
      blocks.unordered_list,
      blocks.hr,
      blocks.blockquote,
      blocks.embedded_entry,
      blocks.embedded_asset
    ]
  end

  # coveralls-ignore-start
end
