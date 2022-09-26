defmodule Content.ContentManagement do
  @base_url "https://api.contentful.com"

  def url,
    do: "#{@base_url}/spaces/#{Content.space_id()}/environments/#{Content.environment_id()}"

  defmacro __using__(parent: parent) do
    {:__MODULE__, [line: _, counter: {parent, _}], _} = parent

    quote do
      defmodule __MODULE__.ContentManagement do
        @gen_server unquote(parent)

        def migrate_content_model() do
          content_types = @gen_server.get_all_content_types()
          Content.ContentManagement.ContentType.migrate_content_model(content_types)
        end

        def get_entry(entry_id) do
          {:ok, entry} = Content.ContentManagement.Entry.get_entry(entry_id)

          case @gen_server.get_content_type(entry["sys"]["contentType"]["sys"]["id"]) do
            nil -> raise "content_type not recognised"
            content_type -> Content.Api.to_entry(entry, content_type)
          end
        end
      end
    end
  end
end
