defmodule Sunbake.ISO8601 do
  @moduledoc """
  ISO8601 Timestampes
  """

  use Ecto.Type
  use Unsafe.Generator, handler: :unwrap, docs: false
  @type t :: DateTime.t()

  # defguard is_timestamp(term) when is_integer(term) and term in 0..0xFFFFFFFFFFFFFFFF
  def type, do: :utc_datetime

  @spec cast(any) :: :error | {:ok, nil | DateTime.t()}
  @unsafe {:cast, [:value]}
  def cast(value)
  def cast(nil), do: {:ok, nil}
  def cast(%DateTime{} = datetime), do: {:ok, datetime}

  def cast(value) when is_binary(value) do
    {:ok, value, 0} = DateTime.from_iso8601(value)
    cast(value)
  end

  def cast(_), do: :error

  def dump(value), do: {:ok, value}

  def load(value) do
    {:ok, value}
  end

  defp unwrap({:ok, body}), do: body
  defp unwrap({:error, _}), do: raise(ArgumentError)
end
