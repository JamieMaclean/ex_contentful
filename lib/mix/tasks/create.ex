defmodule Mix.Tasks.Content.UpdateContentModel do
  @moduledoc "The hello mix task: `mix help hello`"
  use Mix.Task

  @requirements ["app.config"]

  alias Content.ContentManagement

  @doc "Updates the content model on Contentful"
  def run([]) do
    Application.ensure_all_started(:content)
    ContentManagement.migrate_content_model()
  end

  def run(["--publish"]) do
    Application.ensure_all_started(:content)
    ContentManagement.migrate_content_model(:publish)
  end
end
