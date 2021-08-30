defmodule SunbakeTest do
  use ExUnit.Case
  doctest Sunbake

  test "greets the world" do
    assert Sunbake.hello() == :world
  end
end
