defmodule Content.Parser do
  use GenServer

  def start_link(default) when is_list(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  def get_content_type(content_type) do
    GenServer.call(__MODULE__, {:get_type, content_type})
  end

  # Callbacks

  @impl true
  def init(_) do
    {:ok, Content.Entry.all(:content)}
  end

  @impl true
  def handle_call({:get_type, id}, _, content_types) do
    content_type =
      Enum.find(content_types, fn content_type ->
        content_type.__contentful_schema__().id == id
      end)

    {:reply, content_type, content_types}
  end
end
