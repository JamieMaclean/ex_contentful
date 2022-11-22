defmodule Mix.Tasks.ExContentful.UpdateContentModel do
  @moduledoc false
  use Mix.Task

  @requirements ["app.config"]

  alias ExContentful.ContentManagement

  @doc "Updates the content model on Contentful"
  def run([]) do
    Application.ensure_all_started(:ex_contentful)
    ContentManagement.migrate_content_model()
  end

  def run(["--publish"]) do
    Application.ensure_all_started(:ex_contentful)
    ContentManagement.migrate_content_model(:publish)
  end
end
