defmodule Content do
  def space_id(), do: Application.get_env(:content, :space_id)
  def environment_id(), do: Application.get_env(:content, :environment_id)

  defmacro __using__(otp_app: app) do
    quote do
      use GenServer
      use Content.ContentManagement, parent: __MODULE__

      def start_link(default) when is_list(default) do
        GenServer.start_link(__MODULE__, default, name: __MODULE__)
      end

      def get_content_type(content_type) do
        GenServer.call(__MODULE__, {:get_type, content_type})
      end

      def get_all_content_types() do
        GenServer.call(__MODULE__, :get_all_types)
      end

      # Callbacks

      @impl true
      def init(_) do
        state = %{app: unquote(app), content_types: all()}
        {:ok, state}
      end

      @impl true
      def handle_call(:get_all_types, _, %{content_types: content_types} = state) do
        {:reply, content_types, state}
      end

      @impl true
      def handle_call({:get_type, id}, _, %{content_types: content_types} = state) do
        content_type =
          Enum.find(content_types, fn content_type ->
            content_type.__contentful_schema__().id == id
          end)

        {:reply, content_type, state}
      end

      defp all() do
        application = Application.get_application(__MODULE__)
        {:ok, modules} = :application.get_key(application, :modules)

        modules
        |> Enum.filter(&({:__contentful_schema__, 0} in &1.__info__(:functions)))
      end

    end
  end
end
