defmodule Factory.Base do
  @moduledoc false

  @callback build(factory :: atom) :: Ecto.Schema.t() | no_return()

  @callback post(factory :: atom, schema :: Ecto.Schema.t()) :: Ecto.Schema.t()

  @optional_callbacks post: 2

  defmacro __using__(opts) do
    repo = Keyword.get(opts, :repo)

    unless repo do
      raise """
      expected :repo to be given as an option. Example:

          use Factory.Base, repo: MyProject.Repo
      """
    end

    quote do
      @behaviour Factory.Base

      @before_compile Factory.Base

      @spec build(atom, Keyword.t()) :: Ecto.Schema.t() | no_return()
      def build(factory_name, attrs) do
        Factory.Base.build(__MODULE__, factory_name, attrs)
      end

      @spec attrs_for(atom, Keyword.t()) :: map() | no_return
      def attrs_for(factory_name, attrs \\ []) do
        Factory.Base.attrs_for(__MODULE__, factory_name, attrs)
      end

      @spec insert!(atom, Keyword.t()) :: Ecto.Changeset.t() | no_return()
      def insert!(factory_name, attrs \\ []) do
        Factory.Base.insert!(__MODULE__, unquote(repo), factory_name, attrs)
      end

      defdelegate seq(name), to: Factory.Base
      defdelegate seq(name, formatter), to: Factory.Base
    end
  end

  defmacro __before_compile__(_opts) do
    quote do
      def post(_factory, schema), do: schema

      defoverridable post: 2
    end
  end

  @spec build(atom, atom, Keyword.t()) :: Ecto.Schema.t() | no_return()
  def build(module, factory_name, attrs) do
    factory_name
    |> module.build()
    |> struct(attrs)
  end

  @spec attrs_for(atom, atom, Keyword.t()) :: map() | no_return
  def attrs_for(module, factory_name, attrs \\ []) do
    factory_name
    |> module.build(attrs)
    |> Map.from_struct()
  end

  @spec insert!(atom, atom, Keyword.t()) :: Ecto.Changeset.t() | no_return()
  def insert!(module, repo, factory_name, attrs \\ []) do
    schema = module.build(factory_name, attrs)

    factory_name
    |> module.post(schema)
    |> repo.insert!()
  end

  @spec seq(String.t()) :: String.t() | no_return()
  def seq(name), do: seq(name, &"#{name}#{&1}")

  @spec seq(String.t(), (Factory.Sequence.t() -> any())) :: any() | no_return()
  def seq(name, formatter), do: formatter.(Factory.Sequence.next(name))
end
