# Content Model

The first thing we need to do is define the structure of our data.

Lets assume that we are creating a blog. The first content type we want is a `blog_post`. Perhaps we will also allow people to comment on our blog posts, so lets create a `comment` content type as well.

So lets start by defining our `blog_post` content type.

```elixir
defmodule MyApp.BlogPost
  use ExContentful.Schema

  content_type "blog_post" do
    content_field :title, :short_text, required: true
    content_field :author, :short_text # Text with a max length of 256
    content_field :description, :long_text # Text with a max length of 50,000
    content_field :content, :rich_text # Contenful representation of HTML
    content_field :rating, :number # translates to float
    content_field :views, :integer # translates to integer
    content_field :tags, {:array, :short_text}
  end
end
```

Next up, a content type for blog post comments.

```elixir
defmodule MyApp.Comment
  use ExContentful.Schema

  content_type "comment" do
    content_field :blog_post, {:link, MyApp.BlogPost}
    content_field :comment, :short_text
  end
end
```

You can see that this one is a little different. Contentful manages relationships between it's `Entries` with `Links`. A link is essentially a pointer to the appropriate resource. Relationships between content types should always be defined using `Links` as demonstrated above. Think of it as the euqivelent of Ecto's `belongs_to` macro.

## Content Fields

When defining content types, each field has a type which directly maps to a type in Elixir. The Elixir mappings for each of the field types are:

  Contentful type         | Elixir type             | Literal syntax in query
  :---------------------- | :---------------------- | :---------------------
  `:boolean`              | `boolean`               | true, false
  `:integer`              | `integer`               | 1, 2, 3
  `:long_text`            | `string`                | "hello"
  `:number`               | `float`                 | 1.0, 2.0, 3.0
  `:rich_text`            | `struct()`              | `%RichText{}`
  `:short_text`           | `string`                | "hello"
  `{:link, linked_type}`  | `struct()`              | `%Link{}`, or if loaded `%BlogPost{}`
  `{:array, inner_type}`  | `list`                  | `[value, value, value, ...]`

## Update Content Model on Contentul

Now that we have defined our content model it's time to send it to Contentful so that we can start creating entries. From the [Getting Started](getting_started.md) page we configured our app to connect to Contentful so it should just be a case of running the following command:

```elixir
MyApp.ExContentful.migrate_content_model()
```

Whenever any changes are made to your content types you will need to run this command to ensure that your updates are propegated to Contentful. Contentful has certain rules for deleting content types etc. See [Content Model - Advanced](../advanced/content_model_1.md) for more details.

Next up we will start [Creating and Updating Content](create_update_content.md).
