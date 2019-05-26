defmodule Table.WorkerTest do
  use ExUnit.Case, async: true

  doctest Table.Worker

  test "Should return table name" do
    {:ok, _worker} = Table.Worker.start_link("table")
    assert Table.Worker.get_name("table") == "table"
  end

  # setup do
  #   on_exit fn ->
  #     Table.Worker.delete("table")
  #   end
  # end
end
