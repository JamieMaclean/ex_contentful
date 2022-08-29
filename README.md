# Content

Manage Contentful like you manage your database... With Ecto!

Content is a library that can be used to manage both the structure of your data on Contentful as well as the data itself. We have taken inspiration from Ecto with the hope of creating an easy to understand library with a small learning curve due to the similarities we have with Ecto.

This library is in fact a simple wrapper around Ecto with specific added functionality to integrate it with the Contentful API.

## Quick Start

### Define your content

Defining your data is as easy as defining a `contentful_type` with all of the nesesry fields using `contentful_field` for individual fields or `contentful_fields` for an array or fields.

```elixir
contentful_type :blog_post do
  contentful_field :title, :short_text
  contentful_fields :authors, :short_text
  contentful_field :content, :long_text
  contentful_fields :tags, :short_text
end
```


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `content` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:content, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/content>.

