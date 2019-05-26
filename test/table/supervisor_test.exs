defmodule Table.SupervisorTest do
  use ExUnit.Case, async: false

  doctest Table.Supervisor

  test "Should create worker for table" do
    {:ok, _worker} = Table.Supervisor.create_table("table")
    assert Table.Worker.get_name("table") == "table"
  end

  test "Should fail creating duplicate worker for table" do
    {:ok, _worker} = Table.Supervisor.create_table("table")
    {:error, {reason, _pid}} = Table.Supervisor.create_table("table")
    assert :already_started == reason
  end

  setup do
    on_exit fn ->
      Table.Worker.delete("table")
    end
  end
end
