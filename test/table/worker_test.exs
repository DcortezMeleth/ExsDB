defmodule Table.WorkerTest do
  use ExUnit.Case

  doctest Table.Worker

  test "Should return table name" do
    {:ok, _worker} = Table.Worker.start_link("table", [])
    assert Table.Worker.get_name("table") == "table"
  end

  test "Should return columns" do
    {:ok, _worker} = Table.Worker.start_link("table", ["col1"])
    assert Table.Worker.get_columns("table") == ["col1"]
  end

  # setup do
  #   on_exit fn ->
  #     Table.Worker.delete("table")
  #   end
  # end
end
