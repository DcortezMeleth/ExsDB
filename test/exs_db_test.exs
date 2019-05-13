defmodule ExsDBTest do
  use ExUnit.Case
  doctest ExsDB

  test "greets the world" do
    assert ExsDB.hello() == :world
  end
end
