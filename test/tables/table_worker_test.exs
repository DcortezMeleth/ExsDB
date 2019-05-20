defmodule Tables.TableWorkerTest do
  use ExUnit.Case, async: true

  doctest Tables.TableWorker

  test "Should return table name" do
    {:ok, worker} = Tables.TableWorker.start_link("table", [])
    assert Tables.TableWorker.get_name(worker) == "table"
  end
end
