# ExContentful

Manage Contentful using standard Elxir practices without having to do a deep dive into the inner workings of Contentful.

ExContentful is a library that can be used to manage both the structure of your data on Contentful as well as the data itself. We have taken inspiration from Ecto with the hope of creating an easy to understand library with a small learning curve due to the similarities we have with one of the most widely used Elixir libraries.

# Warning

Not ready for use. There are still lots of missing parts.

## Quick Start

### Application Configuration

First add the following in your application config.

```elixir
config :ex_contentful,
  space_id: "my_space_id",
  environment_id: "my_environment_id",
  content_management_token: "content_management_token",
  content_preview_token: "content_preview_token",
  content_delivery_token: "content_delivery_token",
  content_types: [
    MyApp.BlogPost,
    MyApp.Comment,
    MyApp.OtherContentType,
    MyApp.Etc,
  ]
```

### Define your content

Defining your data is as easy as defining a `contentful_type` with all of the necessary fields using `contentful_field`.

```elixir
defmodule MyApp.BlogPost do
  use ExContentful.Schema

  contentful_type :blog_post do
    contentful_field :title, :short_text
    contentful_field :authors, {:array, :short_text}
    contentful_field :content, :long_text, required: true
    contentful_field :tags, {:array, :short_text}
  end
end
```

### Push your content model to Contentful

After defining all of the content types that you need. You can simply run the following command to migrate all of the content types for your entire application.

```
mix ex_contentful.update_content_model
```

If you would like to publish the changes that were made directly you can pass the `--publish` flag.

```
mix ex_contentful.update_content_model --publish
```

### Create and Upload Entries to Contentful

After defining all of your content types you can use them just as you would any other struct. The `create/1` function is injected into every content type module for easy creation and validation of your entries before they are sent to the Contentful API.

```elixir
alias MyApp.BlogPost

BlogPost.create(%{
  title: "My Awesome Blog Post",
  authors: ["Me"],
  content: "ExContentful is a great way to manage your data on Contentful!",
  tags: ["contentful", "cms"]
})
```

Which returns the tuple `{:ok, %BlogPost{}}`.

```elixir
{:ok, %BlogPost{
  authors: ["Me"],
  content: "ExContentful is a great way to manage your data on Contentful!",
  id: nil,
  tags: ["contentful", "cms"]
  title: "My Awesome Blog Post"
}}
```

Entries are automatically validated after being created, so if you do something wrong e.g. leaving `:content` blank from the `BlogPost` content type:

```elixir
{:error,
 #Ecto.Changeset<
   action: :update,
   changes: %{},
   errors: [content: {"can't be blank", [validation: :required]}],
   data: #ExContentful.Integration.BlogPost<>,
   valid?: false
 >}
```

The final step is to send the Entry to Contentful. 

```elixir
ExContentful.Api.update_entry(blog_post)
```

## Installation

Very experimental! Not yet available on Hex.

### Copyright and License

Copyright (c) 2022, Jamie Maclean.

ExContentful source code is licensed under the [MIT License](LICENSE.md).
