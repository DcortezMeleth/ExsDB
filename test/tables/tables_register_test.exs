defmodule Tables.TablesRegisterTest do
  use ExUnit.Case, async: true

  doctest Tables.TablesRegister

  setup do
    registry = start_supervised!(Tables.TablesRegister, [start: {Tables.TablesRegister, :start_link, [["table1", "table2"], [name: TablesRegister]]}])
    %{registry: registry}
  end

  test "should add worker for table" do
    assert Tables.TablesRegister.lookup("table3") == {:error, "Worker for table 'table3' does not exist"}

    assert Tables.TablesRegister.create("table3") == :ok

    {result, _} = Tables.TablesRegister.lookup("table3")
    assert result == :ok
  end

  # test "should delete worker for table" do
  #   {result, _} = Tables.TablesRegister.lookup("table2")
  #   assert result == :ok

  #   assert Tables.TablesRegister.delete("table2") == :ok

  #   assert Tables.TablesRegister.lookup("table2") == {:error, "Worker for table 'table2' does not exist"}
  # end

  test "should delete worker from register after stoping it" do
    {result, worker} = Tables.TablesRegister.lookup("table1")
    assert result == :ok

    GenServer.stop(worker)

    assert Tables.TablesRegister.lookup("table1") == {:error, "Worker for table 'table1' does not exist"}
  end
end
