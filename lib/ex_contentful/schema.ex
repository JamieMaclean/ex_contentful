defmodule ExContentful.Schema do
  @moduledoc """
  This module provides all of the basic building blocks required to create different content types on Contentful.

  The first step when you start using Contentful is to define your Content Model i.e. define all of the building blocks that make up your application. For example if you are creating a blog you will for sure want to define a `blog_post` content type. Perhaps you also allow people to comment on blog posts, in this case you may also want to create a `comment` content type. We are going to stick with this example for now to demonstrate how you can do this using `Content`

  So lets start by defining our `blog_post` content type to begin with.

  ```elixir
  defmodule MyApp.BlogPost
    content_type "blog_post" do
      content_field :title, :short_text, required: true
      content_field :author, :short_text, required: true
      content_field :content, :rich_text
    end
  end
  ```

  So our `blog_post` has three fields: `title`, `author`, and `content`. In reality, you would probably want to make your `content` mandatory as well, but we're not doing that for now for demonstration purposes.

  Next up... our `comment` content type:

  ```elixir
  defmodule MyApp.Comment
    content_type "comment" do
      content_field :blog_post, {:link, MyApp.BlogPost}
      content_field :content, :short_text
    end
  end
  ```

  You can see that this one is a little different. Contentful manages relationships between its `Entries` with `Links`. A link is essentially a pointer to the appropriate resource. Relationships between content types should always be defined using `Links` as demonstrated above.
  """
  alias ExContentful.Schema.FieldArray

  # coveralls-ignore-start
  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
      import ExContentful.Schema

      Module.register_attribute(__MODULE__, :contentful_field, accumulate: true)
      Module.register_attribute(__MODULE__, :content_type_name, accumulate: false)
      Module.register_attribute(__MODULE__, :content_type_id, accumulate: false)
      Module.register_attribute(__MODULE__, :content_display_field, accumulate: false)

      @before_compile {ExContentful.Schema, :add_schema}
    end
  end

  @doc false
  defmacro add_schema(_) do
    quote do
      def __contentful_schema__() do
        base = %{
          name: @content_type_name,
          id: @content_type_id,
          fields: @contentful_field
        }

        case Atom.to_string(@content_display_field) do
          "nil" -> base
          value -> Map.put(base, :displayField, value)
        end
      end

      defimpl ExContentful.Resource do
        alias ExContentful.Schema.Field

        def base_url(_content_type, :content_management) do
          ExContentful.ContentManagement.url() <> "/entries"
        end

        def base_url(_content_type, :content_delivery) do
          ExContentful.ContentDelivery.url() <> "/entries"
        end

        def prepare_for_contentful(resource) do
          fields =
            Map.from_struct(resource)
            |> Map.delete(:id)
            |> Map.delete(:metadata)
            |> Map.delete(:sys)
            |> Map.delete(:__struct__)
            |> Map.keys()
            |> Enum.map(&Field.prepare_for_contentful(resource, &1))
            |> Enum.into(%{})

          %{fields: fields}
        end
      end
    end
  end

  @doc """
  Used in conjuntion with content_field/3 to define a ContentType in Contentful
  """
  defmacro content_type(name, props \\ [], do: block) when is_atom(name) do
    id = props[:id] || Atom.to_string(name)
    display_name = get_default_display_name(name, props)

    quote do
      alias ExContentful.Resource.Link

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

      if unquote(props[:display_field]) do
        Module.put_attribute(
          __MODULE__,
          :content_display_field,
          unquote(props[:display_field])
        )
      end

      @primary_key false
      embedded_schema do
        field(:id, :string)
        field(:metadata, :map, default: %{tags: []})
        field(:sys, :map, default: %{})
        unquote(block)
      end

      def build_from_response(response, :content_management_api) do
        {:ok, created_at, _} = DateTime.from_iso8601(response["sys"]["createdAt"])
        {:ok, updated_at, _} = DateTime.from_iso8601(response["sys"]["updatedAt"])

        {:ok, entry} =
          __MODULE__.__contentful_schema__().fields
          |> Enum.map(fn field -> {field[:id], nil} end)
          |> Enum.map(fn {id, _} -> {id, response["fields"][id]["en-US"]} end)
          |> Enum.map(fn {id, value} -> {String.to_existing_atom(id), value} end)
          |> Enum.filter(fn {_id, value} -> !is_nil(value) end)
          |> Enum.into(%{})
          |> Map.merge(%{
            id: response["sys"]["id"],
            metadata: %{tags: []},
            sys: %{
              id: response["sys"]["id"],
              created_at: created_at,
              content_type: %Link{
                id: response["sys"]["contentType"]["sys"]["id"],
                link_type: response["sys"]["contentType"]["sys"]["linkType"],
                type: response["sys"]["contentType"]["sys"]["type"]
              },
              created_by: %Link{
                id: response["sys"]["createdBy"]["sys"]["id"],
                link_type: response["sys"]["createdBy"]["sys"]["linkType"],
                type: response["sys"]["createdBy"]["sys"]["type"]
              },
              environment: %Link{
                id: response["sys"]["environment"]["sys"]["id"],
                link_type: response["sys"]["environment"]["sys"]["linkType"],
                type: response["sys"]["environment"]["sys"]["type"]
              },
              published_counter: response["sys"]["publishedCounter"],
              space: %Link{
                id: response["sys"]["space"]["sys"]["id"],
                link_type: response["sys"]["space"]["sys"]["linkType"],
                type: response["sys"]["space"]["sys"]["type"]
              },
              type: "Entry",
              updated_at: updated_at,
              updated_by: %Link{
                id: response["sys"]["updatedBy"]["sys"]["id"],
                link_type: response["sys"]["updatedBy"]["sys"]["linkType"],
                type: response["sys"]["updatedBy"]["sys"]["type"]
              },
              version: response["sys"]["version"]
            }
          })
          |> create_from_response()

        entry
      end

      def build_from_response(response, :content_delivery_api) do
        {:ok, created_at, _} = DateTime.from_iso8601(response["sys"]["createdAt"])
        {:ok, updated_at, _} = DateTime.from_iso8601(response["sys"]["updatedAt"])

        {:ok, entry} =
          __MODULE__.__contentful_schema__().fields
          |> Enum.map(fn field -> {field[:id], nil} end)
          |> Enum.map(fn {id, _} -> {id, response["fields"][id]} end)
          |> Enum.map(fn {id, value} -> {String.to_existing_atom(id), value} end)
          |> Enum.filter(fn {_id, value} -> !is_nil(value) end)
          |> Enum.into(%{})
          |> Map.merge(%{
            id: response["sys"]["id"],
            metadata: %{tags: []},
            sys: %{
              id: response["sys"]["id"],
              created_at: created_at,
              content_type: %Link{
                id: response["sys"]["contentType"]["sys"]["id"],
                link_type: response["sys"]["contentType"]["sys"]["linkType"],
                type: response["sys"]["contentType"]["sys"]["type"]
              },
              environment: %Link{
                id: response["sys"]["environment"]["sys"]["id"],
                link_type: response["sys"]["environment"]["sys"]["linkType"],
                type: response["sys"]["environment"]["sys"]["type"]
              },
              space: %Link{
                id: response["sys"]["space"]["sys"]["id"],
                link_type: response["sys"]["space"]["sys"]["linkType"],
                type: response["sys"]["space"]["sys"]["type"]
              },
              type: "Entry",
              updated_at: updated_at
            }
          })
          |> create_from_response()

        entry
      end

      defp create_from_response(params \\ %{}) do
        from_response_changeset(%__MODULE__{}, params)
      end

      def create(params \\ %{}) do
        changeset(%__MODULE__{}, params)
      end

      def update(%__MODULE__{} = entry, params \\ %{}) do
        changeset(entry, params)
      end

      defp changeset(content_type, params \\ %{}) do
        all_fields = Enum.map(@contentful_field, fn %{id: id} -> String.to_existing_atom(id) end)

        required_fields =
          Enum.filter(@contentful_field, fn %{required: required, omitted: omitted} ->
            required && !omitted
          end)
          |> Enum.map(fn %{id: id} -> String.to_existing_atom(id) end)

        content_type
        |> cast(params, [:id, :metadata, :sys] ++ all_fields)
        |> validate_length(:id, max: 64)
        |> validate_required(required_fields)
        |> apply_action(:update)
      end

      defp from_response_changeset(content_type, params \\ %{}) do
        all_fields = Enum.map(@contentful_field, fn %{id: id} -> String.to_existing_atom(id) end)

        content_type
        |> cast(params, [:id, :metadata, :sys] ++ all_fields)
        |> apply_action(:update)
      end
    end
  end

  @doc """
  Used in conjuntion with content_type/3 to define a ContentType in Contentful
  """
  defmacro content_field(name, type, opts \\ [])

  @field_modules %{
    short_text: ExContentful.Field.ShortText,
    long_text: ExContentful.Field.LongText,
    number: ExContentful.Field.Number,
    integer: ExContentful.Field.Integer,
    rich_text: ExContentful.Field.RichText,
    asset: ExContentful.Field.Asset
  }
  defmacro content_field(name, {:array, type}, opts) do
    type = Macro.expand(type, __CALLER__)
    props_field = prepare_props_field(name, type, opts |> Keyword.put(:cardinality, :many))
    field_module = get_field_type(type)
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
    type = Macro.expand(type, __CALLER__)
    props_field = prepare_props_field(name, type, opts |> Keyword.put(:cardinality, :one))
    field_module = get_field_type(type)
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

  @doc false
  def prepare_props_field(name, type, opts) do
    case Keyword.get(opts, :cardinality) do
      :one ->
        field_module = get_field_type(type)
        props = struct(field_module, opts)

        props
        |> Map.from_struct()
        |> add_contetful_specific_props(name, opts, type, :one)
        |> remove_unused_props_for_contentful()

      :many ->
        struct(FieldArray, opts)
        |> Map.from_struct()
        |> add_contetful_specific_props(name, opts, type, :many)
        |> remove_unused_props_for_contentful()
    end
  end

  defp remove_unused_props_for_contentful(props) do
    props
    |> Map.delete(:cardinality)
    |> Map.delete(:contentful_type)
    |> Map.delete(:ecto_type)
    |> Map.delete(:available_options)
  end

  defp add_contetful_specific_props(props, name, opts, field_module, :one) do
    props
    |> Map.put(:name, get_default_display_name(name, opts))
    |> Map.put(:id, Atom.to_string(name))
    |> Map.merge(get_type_spec(props, field_module))
  end

  defp add_contetful_specific_props(props, name, opts, field_module, :many) do
    props
    |> Map.put(:name, get_default_display_name(name, opts))
    |> Map.put(:id, Atom.to_string(name))
    |> Map.put(:items, get_type_spec(props, field_module))
  end

  def get_type_spec(_, type) do
    field_module = get_field_type(type)

    case field_module do
      ExContentful.Field.Link ->
        %{
          type: "Link",
          linkType: "Entry"
        }

      ExContentful.Field.Asset ->
        %{
          type: "Link",
          linkType: "Asset"
        }

      other ->
        %{
          type: struct(other).contentful_type
        }
    end
  end

  defp get_default_value(type) do
    Map.get(
      %{
        string: "",
        map: Macro.escape(%{})
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
    |> Enum.map_join(" ", &String.capitalize(&1))
  end

  defp get_field_type(type) do
    case Map.get(@field_modules, type) do
      nil -> ExContentful.Field.Link
      module -> module
    end
  end

  # coveralls-ignore-end
end
