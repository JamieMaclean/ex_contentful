# Content

Manage Contentful like you manage your database... With Ecto!

Content is a library that can be used to manage both the structure of your data on Contentful as well as the data itself. We have taken inspiration from Ecto with the hope of creating an easy to understand library with a small learning curve due to the similarities we have with one of the modt widely used Elixir libraries.

This library is in fact a simple wrapper around Ecto with specific added functionality to integrate it with the Contentful API.

## Quick Start

### Define your content

Defining your data is as easy as defining a `contentful_type` with all of the nesesry fields using `contentful_field` for individual fields or `contentful_fields` for an array or fields.

```elixir
contentful_type :blog_post do
  contentful_field :title, :short_text
  contentful_field_array :authors, :short_text
  contentful_field :content, :long_text
  contentful_field_array :tags, :short_text
end
```

### Push your content model to Contentful

After defining all of the content types that you need. You can simply run the following command to migrate the content model for your entire application.
```elixir
Content.Api.migrate_content_model(:my_application)
```


## Installation

Very experimental! Not yet available on Hex.
