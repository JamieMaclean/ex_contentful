defmodule Content.ContentManagement do
  @base_url "https://api.contentful.com"

  def url,
    do: "#{@base_url}/spaces/#{Content.space_id()}/environments/#{Content.environment_id()}"

  defmacro __using__(parent: parent) do
    {:__MODULE__, [line: _, counter: {parent, _}], _} = parent

    quote do
      defmodule __MODULE__.ContentManagement do
        def migrate_content_model() do
          content_types = unquote(parent).get_all_content_types()
          Content.ContentManagement.ContentType.migrate_content_model(content_types)
        end
      end
    end
  end
end
