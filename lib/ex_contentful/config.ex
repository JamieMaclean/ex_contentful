defmodule ExContentful.Config do
  @moduledoc false

  def space_id(), do: Application.get_env(:ex_contentful, :space_id)
  def environment_id(), do: Application.get_env(:ex_contentful, :environment_id)
  def content_types(), do: Application.get_env(:ex_contentful, :content_types)
end
