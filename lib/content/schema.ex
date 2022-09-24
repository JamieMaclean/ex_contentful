defmodule Content.Schema do
  @field_modules %{
    short_text: Content.Field.ShortText,
    long_text: Content.Field.LongText,
    number: Content.Field.Number,
    integer: Content.Field.Integer
  }
  alias Content.Schema.FieldArray

  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
      import Content.Schema

      Module.register_attribute(__MODULE__, :contentful_field, accumulate: true)
      Module.register_attribute(__MODULE__, :content_type_name, accumulate: false)
      Module.register_attribute(__MODULE__, :content_type_id, accumulate: false)

      @before_compile {Content.Schema, :add_schema}
    end
  end

  defmacro add_schema(_) do
    quote do
      def __contentful_schema__() do
        %{
          name: @content_type_name,
          id: @content_type_id,
          fields: @contentful_field
        }
      end
    end
  end

  defmacro content_type(name, props \\ [], do: block) when is_atom(name) do
    id = props[:id] || Atom.to_string(name)
    display_name = get_default_display_name(name, props)

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
        field :id, :string
        unquote(block)
      end

      def create(params \\ %{}) do
        changeset(%__MODULE__{}, params)
      end

      def update(%__MODULE__{} = entry, params \\ %{}) do
        changeset(entry, params)
      end

      defp changeset(content_type, params \\ %{}) do
        all_fields = Enum.map(@contentful_field, fn %{id: id} -> String.to_existing_atom(id) end)
        required_fields = Enum.filter(@contentful_field, fn %{required: required, omitted: omitted} -> required && !omitted end)
                          |> Enum.map(fn %{id: id} -> String.to_existing_atom(id) end)

        content_type
        |> cast(params, [:id | all_fields])
        |> validate_length(:id, max: 64)
        |> validate_required(required_fields)
        |> apply_action(:update)
      end
    end
  end

  defmacro content_field(name, type, opts \\ [])

  defmacro content_field(name, {:array, type}, opts) do
    props_field = prepare_props_field(name, type, opts |> Keyword.put(:cardinality, :many))
    field_module = Map.get(@field_modules, type)
    struct = struct(field_module)

    quote do
      Module.put_attribute(
        __MODULE__,
        :contentful_field,
        unquote(Macro.escape(props_field))
      )

      field(unquote(name), {:array, unquote(struct.ecto_type)}, default: [])
    end
  end

  defmacro content_field(name, type, opts) do
    props_field = prepare_props_field(name, type, opts |> Keyword.put(:cardinality, :one))
    field_module = Map.get(@field_modules, type)
    struct = struct(field_module)

    default_value = get_default_value(struct.ecto_type)

    quote do
      Module.put_attribute(
        __MODULE__,
        :contentful_field,
        unquote(Macro.escape(props_field))
      )

      field(unquote(name), unquote(struct.ecto_type), default: unquote(default_value))
    end
  end

  def prepare_props_field(name, type, opts) do
    case Keyword.get(opts, :cardinality) do
      :one ->
        field_module = Map.get(@field_modules, type)
        props = struct(field_module, opts)

        props
        |> Map.from_struct()
        |> Map.delete(:type)
        |> Map.delete(:cardinality)
        |> Map.delete(:items)
        |> Map.delete(:contentful_type)
        |> Map.delete(:ecto_type)
        |> Map.delete(:available_options)
        |> Map.put(:type, props.contentful_type)
        |> Map.put(:name, get_default_display_name(name, opts))
        |> Map.put(:id, Atom.to_string(name))

      :many ->
        struct(FieldArray, opts)
        |> Map.from_struct()
        |> Map.delete(:contentful_type)
        |> Map.delete(:cardinality)
        |> Map.delete(:available_options)
        |> Map.put(:name, get_default_display_name(name, opts))
        |> Map.put(:id, Atom.to_string(name))
        |> Map.put(:items, %{type: "Symbol", validations: []})
    end
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

  defp get_default_display_name(name, opts) do
    case Keyword.get(opts, :name) do
      name when is_binary(name) -> name
      _ -> get_default_display_name(name)
    end
  end

  defp get_default_display_name(name) do
    name
    |> Atom.to_string()
    |> String.split("_")
    |> Enum.map(&String.capitalize(&1))
    |> Enum.join(" ")
  end
end
