defmodule Sunbake.Snowflake do
  @moduledoc """
  Snowflakes
  """
  use Bitwise, only_operators: true
  use Ecto.Type
  @discord_epoch 1_420_070_400_000

  @type t :: 0..0xFFFFFFFFFFFFFFFF
  defguard is_snowflake(term) when is_integer(term) and term in 0..0xFFFFFFFFFFFFFFFF
  def type, do: :id

  @doc """
  Cast the integer to its snowflake representation.

    ## Examples

        iex> Sunbake.cast(381887113391505410)
        {:ok, 381887113391505410}

        iex> Sunbake.cast("bad_value")
        :error

  """
  def cast(value)
  def cast(nil), do: {:ok, nil}
  def cast(value) when is_snowflake(value), do: {:ok, value}

  def cast(value) when is_binary(value) do
    case Integer.parse(value) do
      {snowflake, _} -> cast(snowflake)
      _ -> :error
    end
  end

  def cast(_), do: :error

  @doc """
  Banged version of `cast/1`.
  """
  def cast!(value) do
    cast(value) |> bangify!()
  end

  @doc """
  Dumps a string version of the snowflake

  ## Examples

      iex> Sunbake.dump(381887113391505410)
      {:ok, "381887113391505410"}

  """
  def dump(snowflake) when is_snowflake(snowflake), do: {:ok, to_string(snowflake)}

  @doc """
  Loads the underlying type into the snowflake type

  ## Examples

      iex> Sunbake.load(381887113391505410)
      {:ok, 381887113391505410}
  """
  def load(id) when is_integer(id) do
    {:ok, cast!(id)}
  end

  def load(id) when is_binary(id) do
    {:ok,
     id
     |> Integer.parse()
     |> Tuple.to_list()
     |> List.first()
     |> cast!()}
  end

  @doc """
  Convers an elxiir %DateTime{} into its snowflake form.

  Obviously this does not include the non time components of the snowflake. But it does allow you to order a datetime with snowflakes.

    ## Examples

        iex> DateTime.now!("Etc/UTC")
        ...> Sunbake.from_datetime()
        "381887113391505410"
  """
  def from_datetime(%DateTime{} = datetime) do
    discord_time_ms = DateTime.to_unix(datetime, :millisecond) - @discord_epoch

    if discord_time_ms >= 0 do
      {:ok, discord_time_ms <<< 22}
    else
      :error
    end
  end

  @doc """
  Banged version of `from_datetime/1`
  """
  @spec from_datetime!(DateTime.t()) :: nil | integer
  def from_datetime!(datetime) do
    from_datetime(datetime)
    |> bangify!()
  end

  @doc """
  Opposite of `from_datetime/1`
  """
  def to_datetime(snowflake) when is_snowflake(snowflake) do
    snowflake
    |> to_elapsed()
    |> DateTime.from_unix!(:millisecond)
  end

  defp bangify!({:ok, term}), do: term
  defp bangify!(:error), do: raise(ArgumentError)

  defp to_elapsed(snowflake) when is_snowflake(snowflake) do
    snowflake >>> (22 + @discord_epoch)
  end
end
