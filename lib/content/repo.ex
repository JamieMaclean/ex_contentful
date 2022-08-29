defmodule Content.Repo do
  defmacro __using__(_opts) do 
    IO.inspect(__CALLER__)
    IO.inspect(:application.get_key(:content, :modules))
    quote do
      def get_all_content_types() do
        {:ok, modules} = Application.get_application(__MODULE__)
        |> :application.get_key(:modules)

        Enum.filter(modules, fn module -> 
          :application.get_key(:funtions)
          Module.g
        end)
      end
    end
  end
end
