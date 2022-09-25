defmodule Content do
  use Application

  def space_id(), do: Application.get_env(:content, :space_id)
  def environment_id(), do: Application.get_env(:content, :environment_id)

  def start(_type, _args) do
    children = [Content.Parser]
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
