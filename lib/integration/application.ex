defmodule Content.Integration do
  use Application

  def start(_type, _args) do
    children = [
      {Content.Integration.Repo, [Content.Integration.Repo]}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Content.Integration)
  end
end
