# Content

Manage Contentful using standard Elxir practices without having to do a deep dive into the inner workings of Contentful.

Content is a library that can be used to manage both the structure of your data on Contentful as well as the data itself. We have taken inspiration from Ecto with the hope of creating an easy to understand library with a small learning curve due to the similarities we have with one of the most widely used Elixir libraries.

# Warning

Not ready for use. There are still lots of missing parts.

## Quick Start

### Application Configuration

First add the following in your application config.

```elixir
config :content,
  space_id: "my_space_id",
  environment_id: "my_environment_id",
  content_management_token: "content_management_token",
  content_preview_token: "content_preview_token",
  content_delivery_token: "content_delivery_token"
```

### Define your content

Defining your data is as easy as defining a `contentful_type` with all of the necessary fields using `contentful_field`.

```elixir
defmodule MyApp.BlogPost do
  use Content.Schema

  contentful_type :blog_post do
    contentful_field :title, :short_text
    contentful_field_array :authors, {:array, :short_text}
    contentful_field :content, :long_text
    contentful_field_array :tags, :short_text
  end
end
```

### Push your content model to Contentful

After defining all of the content types that you need. You can simply run the following command to migrate all of the content types for your entire application.

```elixir
Content.Api.migrate_content_model(:my_app)
```


## Installation

Very experimental! Not yet available on Hex.
