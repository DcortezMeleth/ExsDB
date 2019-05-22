defmodule Tables.TablesSupervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
      children = [
        # %{id: Tables.WorkersSupervisor, start: {DynamicSupervisor, :start_link, [name: Tables.WorkersSupervisor, strategy: :one_for_one]}},
        {DynamicSupervisor, name: Tables.WorkersSupervisor, strategy: :one_for_one},
        %{id: Tables.TablesRegister, start: {Tables.TablesRegister, :start_link, [["table1", "table2"], [name: TablesRegister]]}}
        # worker(Tables.TablesRegister, [["table1", "table2"], [name: TablesRegister]]),
        # worker(Tables.TablesRegister, [["table1", "table2"], name: TablesRegister])
        # %{
        #   id: Tables.TablesRegister,
        #   start: {Tables.TablesRegister, :start_link, [["table1", "table2"], name: TablesRegister]}
        # }
      ]

      Supervisor.init(children, strategy: :one_for_one)
  end
end
