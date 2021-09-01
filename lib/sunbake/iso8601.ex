defmodule Sunbake.ISO8601 do
  @moduledoc """
  ISO8601 Timestampes
  """

  use Ecto.Type

  # defguard is_timestamp(term) when is_integer(term) and term in 0..0xFFFFFFFFFFFFFFFF
  def type, do: :string

  def cast(value)
  def cast(nil), do: {:ok, nil}
  def cast(value) when is_binary(value), do: {:ok, value}

  def cast(_), do: :error

  def dump(value) when is_binary(value), do: {:ok, value}

  def load(value) when is_binary(value) do
    {:ok, value}
  end
end
