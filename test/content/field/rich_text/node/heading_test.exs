defmodule Content.Field.RichText.Node.HeadingTest do
  use ExUnit.Case

  alias Content.Field.RichText.ValidationError
  alias Content.Field.RichText.Node
  alias Content.Field.RichText.Node.{Heading1, Heading2, Heading3, Heading4, Heading5, Heading6}
  alias Content.Field.RichText.Node.Paragraph
  alias Content.Field.RichText.Node.Text

  describe "Node.validate/1" do
    test "returns the node when content is empty" do
      heading_1 = %Heading1{content: []}
      heading_2 = %Heading2{content: []}
      heading_3 = %Heading3{content: []}
      heading_4 = %Heading4{content: []}
      heading_5 = %Heading5{content: []}
      heading_6 = %Heading6{content: []}

      assert Node.validate(heading_1) == heading_1
      assert Node.validate(heading_2) == heading_2
      assert Node.validate(heading_3) == heading_3
      assert Node.validate(heading_4) == heading_4
      assert Node.validate(heading_5) == heading_5
      assert Node.validate(heading_6) == heading_6
    end

    test "returns the node when valid" do
      heading_1 = %Heading1{content: [%Text{}]}
      heading_2 = %Heading2{content: [%Text{}]}
      heading_3 = %Heading3{content: [%Text{}]}
      heading_4 = %Heading4{content: [%Text{}]}
      heading_5 = %Heading5{content: [%Text{}]}
      heading_6 = %Heading6{content: [%Text{}]}

      assert Node.validate(heading_1) == heading_1
      assert Node.validate(heading_2) == heading_2
      assert Node.validate(heading_3) == heading_3
      assert Node.validate(heading_4) == heading_4
      assert Node.validate(heading_5) == heading_5
      assert Node.validate(heading_6) == heading_6
    end

    test "returns the paragraph when valid" do
      heading_1 = %Heading1{content: [%Paragraph{}]}
      heading_2 = %Heading2{content: [%Paragraph{}]}
      heading_3 = %Heading3{content: [%Paragraph{}]}
      heading_4 = %Heading4{content: [%Paragraph{}]}
      heading_5 = %Heading5{content: [%Paragraph{}]}
      heading_6 = %Heading6{content: [%Paragraph{}]}

      assert %ValidationError{node: ^heading_1, received: [%Paragraph{}]} =
               Node.validate(heading_1)

      assert %ValidationError{node: ^heading_2, received: [%Paragraph{}]} =
               Node.validate(heading_2)

      assert %ValidationError{node: ^heading_3, received: [%Paragraph{}]} =
               Node.validate(heading_3)

      assert %ValidationError{node: ^heading_4, received: [%Paragraph{}]} =
               Node.validate(heading_4)

      assert %ValidationError{node: ^heading_5, received: [%Paragraph{}]} =
               Node.validate(heading_5)

      assert %ValidationError{node: ^heading_6, received: [%Paragraph{}]} =
               Node.validate(heading_6)
    end
  end
end
