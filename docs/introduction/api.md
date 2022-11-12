# Contentful API

Contentful has a number of APIs that can be used to query and update data. The API you use depends on exactly what it is you want to do:

#### Content Management API 
Used whenever you want to make any changes to the data e.g. create or update an `Entry` or a `ContentType` etc.
#### Content Delivery API
A read only API used for fetching published data.
#### Content Preview API
A read only API used for fetching data that is not yet public.

## How to Use the APIs

`Content` defines the `Query` module for each of the APIs listed above. Using the appropriate `Query` module you can access the full Contentful API. The three `Query` modules that can be used to access your data on Contentful are explained in the following modules:

- Content Management API: `ExContentful.ContentManagement.Query`
- Content Delivery API: `ExContentful.ContentDelivery.Query`
- Content Preview API: `ExContentful.ContentPreview.Query`
