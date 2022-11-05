# Transforming Rich Text

The final step in the implementation is to consume the Contentful API and deliver your content to wherever it needs to go. In the case of Rich Text fields however some additional work is required to transform it into html that can be displayed in your application.

## Basic Transformation

Luckily `Content` comes with a plug 'n' play adapter that can be used and customised for easy transformation of `RichText` to HTML. To use the default adapter just create something similar to the following module in your application.

```elixir
defmodule MyApp.Contentful.RichTextAdapter do
  use Content.RichText.Adapter
end
```

This will bootstrap your adapter with all of the functions you need to transform your Rich Text into HTML. See XXXXX for details on the full functionality of this module.

Now you are ready to call this module to transform the Rich Text you are receiving from Contentful.

```elixir
alias MyApp.Contentful.RichTextAdapter

%Document{content: [
  %Paragraph{content: [
    %Text{value: "Nice parser"}
  ]}
]}
|> RichTextAdapter.to_html()


"<p>Nice parser</p>"
```

Note that the default adapter makes no assumptions. It simply converts the Rich Text directly to its HTML equivalent. This is good, but is probably insufficient for just about any application. You'll probably want to add classes and other attributes to your HTML.

To do this `Content.RichText.Adapter` has the `def_html` macro. So lets revisit the adapter we created and add our own custom html pattern

```elixir
defmodule MyApp.Contentful.RichTextAdapter do
  use Content.RichText.Adapter
  
  def_html %Paragraph{content: content} do
    {"p", [{"class", "paragraph bold myOtherClasses"}], parse_content(content)}
  end
end
```

Now lets parse the exact same Rich Text as before

```elixir
alias MyApp.Contentful.RichTextAdapter

%Document{content: [
  %Paragraph{content: [
    %Text{value: "Nice parser"}
  ]}
]}
|> RichTextAdapter.to_html()

"<p class='paragraph bold myOtherClasses'>Nice parser</p>"
```

So lets unpack the `def_html` macro to understand exactly what's happening here. There are two main components of this macro. The first is the rich text pattern that you would like to transform. Previously we passed `%Paragraph{content: content}` as the pattern we wanted to match.

The second part of the macro is the do block. This block behaves just like any other function. `Content` uses `Floki` to do the heavy lifting when transforming into HTML, for that reason the returned value of this macro must be a Floki parsed HTML tupple. This tupple will then be transformed to html.

The final thing to note here is that you will see that we called `parse_content(content)` in our function. This is because we are overriding the default adapter, so if we want to continue down the HTML tree and parse the contents of the paragraph we have tell the adapter explicitly to continue.

## A More Complex Example

Through the magic of Elixir pattern matching we are able to use the `def_html` macro to do pretty much anything we want. Lets say for example that we decide that a single paragraph that falls between two `<hr />` tags should have red text. We also want to remove the <hr /> tags themselves. We can do this as follows.

```elixir
defmodule MyApp.Contentful.RichTextAdapter do
  use Content.RichText.Adapter
  
  # If we want to remove the hr tags
  def_html [%Hr{}, %Paragraph{content: content}, %Hr{}] do
    {"p", [{"class", "redText"}], parse_content(content)}
  end

  # If we want to keep the hr tags
  def_html [%Hr{}, %Paragraph{content: content}, %Hr{}] do
    [{"hr", [], []}, {"p", [{"class", "redText"}], parse_content(content)}, {"hr", [], []}]
  end
end
```

## Custom Content Types

Contenful allows you to embed custom content types within your Rich Text, that means that you could potentially have something like a `%TableOfContents{}` embedded within your Rich Text. The process is exactly the same for matching custom content types as it is for standard Rich Text.

```elixir
defmodule MyApp.Contentful.RichTextAdapter do
  use Content.RichText.Adapter
  alias MyApp.Contentful.TableOfContents
  
  def_html [%TableOfContents{items: items}] do
    heading = {"h1", [], ["In This Blog Post"]}
    items = Enum.map(items, fn item -> {"span", [], [item.text]})

    [heading | items]
  end
end
```

This gives you the flexibility to transform any pattern that you like into the corresponding html for your application.

Given the fact that you can define additional content types and embed them within your Rich Text it isn't necessary to define patterns that are too complex but, if you are strapped for cash and want to stay below the 25,000 entries limit for the free tier, this is a good option to help keep the number of entries low.

## Using With Tailwind

Tailwind is great choice for quickly building applications with utility classes. You will however notice that it does not work out of the box if your adapter is not located within your `*_web/` directory. This is because Tailwind only bundles the classes that it finds at compile time. So you'll have to add your adapter files to the list of files that it should scan at compile time. It's an easy one liner. Add the following to your `./assets/tailwind.config.js`

```elixir
module.exports = {
  content: [
    './js/**/*.js',
    '../lib/*_web.ex',
    '../lib/*_web/**/*.*ex',
    '../lib/path/to/my/adapter.ex', # Add this line to scan your adapter
  ]
}
```

Now tailwind will bundle all of the classes that it finds in your adapters.
