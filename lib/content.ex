defmodule Content do
  @moduledoc false

  def space_id(), do: Application.get_env(:content, :space_id)
  def environment_id(), do: Application.get_env(:content, :environment_id)
  def content_types(), do: Application.get_env(:content, :content_types)
end
