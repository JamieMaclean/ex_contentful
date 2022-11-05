# Getting Started

## Installation

Add it as a dependency in your `mix.exs`.
```elixir
{:content, "~> 0.1.0"}
```

## Configuration

You'll need to add the following fields inside your config for your different environments. These values are only ever used at runtime, so we'll leave it up to whether you want to put them in your compile time or runtime config.

```elixir
config :content, MyApp,
  space_id: "my_space_id",
  environment_id: "my_environment_id",
  content_management_token: "content_management_token",
  content_preview_token: "content_preview_token",
  content_delivery_token: "content_delivery_token"
```

Now that `Content` has been fully configured you are ready to start defining your [Content Model](content_model.md).

