defmodule Content.Repo do
  defmacro __using__(_opts) do
    quote do
      def child_spec(opts) do
        %{
          id: __MODULE__,
          start: {__MODULE__, :start_link, [opts]},
          type: :supervisor
        }
      end

      def start_link(opts \\ []) do
        Content.Repo.Supervisor.start_link(opts)
      end
    end
  end
end
