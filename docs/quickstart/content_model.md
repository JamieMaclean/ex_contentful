# Content Model

### Content Types and Fields

When defining content types, each field has a type which directly maps to a type in Elixir. The Elixir mappings for each of the field types are:

  Contentful type         | Elixir type             | Literal syntax in query
  :---------------------- | :---------------------- | :---------------------
  `:integer`              | `integer`               | 1, 2, 3
  `:number`               | `float`                 | 1.0, 2.0, 3.0
  `:boolean`              | `boolean`               | true, false
  `:short_text`           | `string`                | "hello"
  `:long_text`            | `string`                | "hello"
  `{:array, inner_type}`  | `list`                  | `[value, value, value, ...]`
