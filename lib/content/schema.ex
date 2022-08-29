defmodule Content.Schema do
  @field_modules %{
    short_text: Content.Field.ShortText,
    long_text: Content.Field.LongText
  }

  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
      import Content.Schema

      Module.register_attribute(__MODULE__, :contentful_field, accumulate: true)
      Module.register_attribute(__MODULE__, :content_type_name, accumulate: false)
      Module.register_attribute(__MODULE__, :content_type_id, accumulate: false)

      def __contentful_schema__(), do: true

      @before_compile {Content.Schema, :add_schema}
    end
  end

  defmacro add_schema(_) do
    quote do
      def contentful_schema() do
        %{
          name: @content_type_name,
          id: @content_type_id,
          fields: @contentful_field |> Enum.into(%{})
        }
      end
    end
  end

  defmacro contentful_type(name, props \\ [], do: block) when is_atom(name) do
    id = props[:id] || Atom.to_string(name)
    display_name = props[:name] || get_default_display_name(name)

    quote do
      Module.put_attribute(
        __MODULE__,
        :content_type_id,
        unquote(id)
      )

      Module.put_attribute(
        __MODULE__,
        :content_type_name,
        unquote(display_name)
      )

      @primary_key false
      embedded_schema do
        unquote(block)
      end
    end
  end

  defmacro contentful_field(name, type, opts \\ []) do
    props_field = prepare_props_field(name, type, opts |> Keyword.put(:cardinality, :one))

    default_value = get_default_value(props_field.type)

    quote do
      Module.put_attribute(
        __MODULE__,
        :contentful_field,
        {unquote(name), unquote(Macro.escape(props_field))}
      )

      field(unquote(name), unquote(props_field.type), default: unquote(default_value))
    end
  end

  defmacro contentful_fields(name, type, opts \\ []) do
    props_field = prepare_props_field(name, type, opts |> Keyword.put(:cardinality, :many))

    quote do
      Module.put_attribute(
        __MODULE__,
        :contentful_field,
        {unquote(name), unquote(Macro.escape(props_field))}
      )

      field(unquote(name), {:array, unquote(props_field.type)}, default: [])
    end
  end

  def prepare_props_field(name, type, opts) do
    opts =
      opts
      |> Keyword.delete(:type)
      |> Keyword.delete(:contentful_type)
      |> Keyword.put_new(:name, get_default_display_name(name))
      |> Keyword.put_new(:id, Atom.to_string(name))

    field_module = Map.get(@field_modules, type)
    props = struct(field_module, opts) |> Map.from_struct()

    props
  end

  defp get_default_value(type) do
    Map.get(
      %{
        string: "",
        map: %{}
      },
      type
    )
  end

  defp get_default_display_name(name) do
    name
    |> Atom.to_string()
    |> String.split("_")
    |> Enum.map(&String.capitalize(&1))
    |> Enum.join(" ")
  end
end
