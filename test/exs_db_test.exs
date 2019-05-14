defmodule ExsDBTest do
  use ExUnit.Case
  doctest ExsDB

  test "DB should start on default port" do
    assert ExsDB.start() == {:ok, 9999}
  end

  test "DB should start on given port" do
    assert ExsDB.start(%{port: 7899}) == {:ok, 7899}
  end

  test "DBs on different ports should be able to start at the same time" do
    assert ExsDB.start(%{port: 7777}) == {:ok, 7777}
    assert ExsDB.start(%{port: 7778}) == {:ok, 7778}
  end

  test "DBs on same ports should not be able to start at the same time" do
    assert ExsDB.start(%{port: 7777}) == {:ok, 7777}
    assert ExsDB.start(%{port: 7777}) == {:error, "Port already in use."}
  end
end
