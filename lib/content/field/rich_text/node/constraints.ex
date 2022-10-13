defmodule Content.Field.RichText.Node.Constraints do
  @moduledoc """
  Explain constraints
  """

  # Functions in this module are only ever called at compile-time. It is therefore
  # not relevant whether or not they are covered.
  #
  # coveralls-ignore-start
  def blocks,
    do: %{
      document: "document",
      paragraph: "paragraph",
      heading_1: "heading-1",
      heading_2: "heading-2",
      heading_3: "heading-3",
      heading_4: "heading-4",
      heading_5: "heading-5",
      heading_6: "heading-6",
      ol_list: "ordered-list",
      ul_list: "unordered-list",
      list_item: "list-item",
      hr: "hr",
      quote: "blockquote",
      embedded_entry: "embedded-entry-block",
      embedded_asset: "embedded-asset-block",
      table: "table",
      table_row: "table-row",
      table_cell: "table-cell",
      table_header_cell: "table-header-cell"
    }

  def inlines,
    do: %{
      hyperlink: "hyperlink",
      entry_hyperlink: "entry-hyperlink",
      asset_hyperlink: "asset-hyperlink",
      inline_entry: "embedded-entry-inline"
    }

  def marks,
    do: %{
      bold: "bold",
      italic: "italic",
      underline: "underline",
      code: "code"
    }

  def top_level_blocks do
    blocks = blocks()

    [
      blocks.paragraph,
      blocks.heading_1,
      blocks.heading_2,
      blocks.heading_3,
      blocks.heading_4,
      blocks.heading_5,
      blocks.heading_6,
      blocks.ol_list,
      blocks.ul_list,
      blocks.hr,
      blocks.quote,
      blocks.embedded_entry,
      blocks.embedded_asset,
      blocks.table
    ]
  end

  def list_item_blocks do
    blocks = blocks()

    [
      blocks.paragraph,
      blocks.heading_1,
      blocks.heading_2,
      blocks.heading_3,
      blocks.heading_4,
      blocks.heading_5,
      blocks.heading_6,
      blocks.ol_list,
      blocks.ul_list,
      blocks.hr,
      blocks.quote,
      blocks.embedded_entry,
      blocks.embedded_asset
    ]
  end

  def void_blocks do
    blocks = blocks()

    [
      blocks.hr,
      blocks.embedded_entry,
      blocks.embedded_asset
    ]
  end

  def containers do
    blocks = blocks()

    %{
      blocks.ol_list => [blocks.list_item],
      blocks.ul_list => [blocks.list_item],
      blocks.list_item => list_item_blocks(),
      blocks.quote => [blocks.paragraph],
      blocks.table => [blocks.table_row],
      blocks.table_row => [blocks.table_cell, blocks.table_header_cell],
      blocks.table_cell => [blocks.paragraph],
      blocks.table_header_cell => [blocks.paragraph]
    }
  end

  # coveralls-ignore-start
end
