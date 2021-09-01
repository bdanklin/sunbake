defmodule Sunbake do
  @moduledoc """
  Easy discord types for Ecto.

  Say you have a schema helper such that

  ```elixir
    defmodule MyApp.Schema do
      defmacro __using__(_) do

        parent = __MODULE__
        quote do
          use Ecto.Schema
          import Ecto.Changeset
          alias unquote(parent)
          @before_compile
        end
      end

      defmacro __before_compile__(_env) do
        quote do
          alias MyApp.Schema.{Application, Channel, Emoji, Guild, Sticker, User, Voice, Webhook}
        end
      end
    end```

  That enables you to `use MyApp.Schema` to bring in all of the relevant alias and imports for your schema module.

  Simply add the alias to the types you wish to use. eg

  ```elixir
    defmodule MyApp.Schema do
      defmacro __using__(_) do

        parent = __MODULE__
        quote do
          use Ecto.Schema
          import Ecto.Changeset
          alias Sunbake.{Snowflake, ISO8601} ## <<-- Add This
          alias unquote(parent)
          @before_compile
        end
      end

      defmacro __before_compile__(_env) do
        quote do
          alias MyApp.Schema.{Application, Channel, Emoji, Guild, Sticker, User, Voice, Webhook}
        end
      end
    end```


  """
end
