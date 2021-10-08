defmodule Sunbake.Snowflake do
  @discord_epoch 1_420_070_400_000
  @moduledoc """
  Module for assisting with Discord Snowflakes.
  """
  use Bitwise, only_operators: true
  use Ecto.Type
  use Unsafe.Generator, handler: :unwrap, docs: false
  @type t :: 0..0xFFFFFFFFFFFFFFFF

  defguard is_snowflake(term) when is_integer(term) and term in 0..0xFFFFFFFFFFFFFFFF

  @spec type :: :integer
  def type, do: :integer

  @doc """
  Cast the integer to its snowflake representation.

    ## Examples

        iex> Sunbake.Snowflake.cast(381887113391505410)
        {:ok, 381887113391505410}

        iex> Sunbake.Snowflake.cast("381887113391505410")
        {:ok, 381887113391505410}

        iex> Sunbake.Snowflake.cast(DateTime.now())

        iex> Sunbake.cast("bad_value")
        :error

  """
  @unsafe {:cast, [:value]}
  def cast(value)
  def cast(nil), do: {:ok, nil}
  def cast(value) when is_snowflake(value), do: {:ok, value}

  def cast(value) when is_binary(value) do
    case Integer.parse(value) do
      {snowflake, _} -> cast(snowflake)
      _ -> :error
    end
  end

  def cast(%DateTime{} = datetime) do
    use Bitwise
    unix_time_ms = DateTime.to_unix(datetime, :millisecond)
    discord_time_ms = unix_time_ms - @discord_epoch

    if discord_time_ms >= 0 do
      {:ok, discord_time_ms <<< 22}
    else
      :error
    end
  end

  def cast(_), do: :error

  @doc """
  Dumps a string version of the snowflake

  ## Examples

      iex> Sunbake.Snowflake.dump(381887113391505410)
      {:ok, 381887113391505410}

  """
  @unsafe {:dump, [:snowflake]}
  def dump(snowflake) when is_snowflake(snowflake), do: {:ok, to_string(snowflake)}

  @doc false
  @unsafe {:load, [:id]}
  def load(id) when is_integer(id) do
    {:ok, cast!(id)}
  end

  def load(id) when is_binary(id) do
    {:ok,
     id
     |> Integer.parse()
     |> elem(0)
     |> cast!()}
  end

  @doc """
  Convers an elxiir %DateTime{} into its snowflake form.

  Obviously this does not include the non time components of the snowflake. But it does allow you to order a datetime with snowflakes.

    ## Examples

        iex> DateTime.now!("Etc/UTC") |> Sunbake.Snowflake.from_datetime()
        "381887113391505410"

  """

  def to_datetime(snowflake) when is_snowflake(snowflake) do
    ((snowflake >>> 22) + @discord_epoch)
    |> DateTime.from_unix!(:millisecond)
  end

  defp unwrap({:ok, body}), do: body
  defp unwrap({:error, _}), do: raise(ArgumentError)
end
