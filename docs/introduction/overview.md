# Overview

Contentful is a headless CMS that allows you to store, manage, and deliver your content to your production instances.

Direct from the Contentful website, they sell themselves as having a three step process: 

*"First of all, you define a content model which is independent from any presentation layer that defines what kind of content you want to manage. In a second step, you and other internal or external editors can manage all of the content in our easy-to-use and interactive editing interface. Last but not least, we serve the content in a presentation-independent way, and you can take the content and create engaging experiences around it. Contentful is therefore completely adapted to your needs."*

When implementing Contentful with Elixir, `Content` vastly simplifies steps one and three of this process. It won't create the content for you but will also make it easy to create and update content in step two without ever having to login and visit the UI.

In the following sections we'll do our best to get you up and running without having to visit the official Contentful docs. But that's not to say you shouldn't read them. Some useful links on getting started and understanding Contentful as a service can be found here:

- Contentful Homepage: https://www.contentful.com/
- Pricing: https://www.contentful.com/pricing/
- The Docs: https://www.contentful.com/developers/docs/
- API Reference: https://www.contentful.com/developers/docs/references/

Conentful is a paid service, but the good news is that they provide a decent sized free tier of up to 25,000 entries, which should be enough for a small shop or any medium sized blog.

## Before You Start

Before jumping into the code and implementing `Content` in your application, you will of course need an account on Contentful. After creating your account, go ahead and generate some API keys and we can dive right into the next section [Getting Started](getting_started.md)
