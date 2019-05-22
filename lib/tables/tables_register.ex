defmodule Tables.TablesRegister do
  use GenServer

  require Logger

  # Client API
  def start_link(tables, opts) do
    GenServer.start_link(__MODULE__, tables, opts)
  end

  def lookup(table_name) do
    GenServer.call(TablesRegister, {:lookup, table_name})
  end

  def create(table_name) do
    GenServer.call(TablesRegister, {:create, table_name})
  end

  # Server callbacks
  def init(tables) when is_list(tables) do
    workers = tables
              |> Enum.reduce(%{}, fn table_name, acc ->
                Map.put(acc, table_name, DynamicSupervisor.start_child(Tables.WorkersSupervisor, %{id: Tables.TableWorker, start: {Tables.TableWorker, :start_link, [table_name, []]}}) |> elem(1))
              end)

    refs = workers
    |> Map.to_list
    |> Enum.reduce(%{}, fn {table_name, pid}, acc ->
      Map.put(acc, Process.monitor(pid), table_name)
          end)

    {:ok, {workers, refs}}
  end

  def handle_call({:lookup, table_name}, _from, {workers, refs}) do
    if(Map.has_key?(workers, table_name)) do
      {:reply, Map.fetch(workers, table_name), {workers, refs}}
    else
      Logger.debug("Worker for table '#{table_name}' does not exist")
      {:reply, {:error, "Worker for table '#{table_name}' does not exist"}, {workers, refs}}
      # TODO: create some func to not duplicate error msg
    end
  end

  def handle_call({:create, table_name}, _from, {workers, refs}) do
    if(Map.has_key?(workers, table_name)) do
      Logger.debug("Worker for table '#{table_name}' already exists")
      {:reply, {:error, "Worker for table '#{table_name}' already exists"}, {workers, refs}}
    else
      # {:ok, worker} = Tables.TableWorker.start_link(table_name, [])
      # %{id: Tables.TablesRegister, start: {Tables.TablesRegister, :start_link, [["table1", "table2"], [name: TablesRegister]]}},
      {:ok, worker} = DynamicSupervisor.start_child(Tables.WorkersSupervisor, %{id: Tables.TableWorker, start: {Tables.TableWorker, :start_link, [table_name, []]}})
      # {:ok, worker} = DynamicSupervisor.start_child(Tables.WorkersSupervisor, {Tables.TableWorker, [table_name]})
      ref = Process.monitor(worker)
      workers = Map.put(workers, table_name, worker)
      refs = Map.put(refs, table_name, ref)
      {:reply, :ok, {workers, refs}}
    end
  end

  def handle_info({:DOWN, ref, :process, _pid, reason}, {workers, refs}) do
    {table_name, refs} = Map.pop(refs, ref)
    Logger.debug("reason: #{reason}")
    Logger.debug("Removing worker #{table_name} from reigster")
    workers = Map.delete(workers, table_name)
    {:noreply, {workers, refs}}
  end

  def handle_info({x, ref, :process, pid, reason}, {workers, refs}) do
    {:ok, table_name} = Map.fetch(refs, ref)
    Logger.debug("Received unknown msg {#{x}, #{pid}, #{reason}} for worker #{table_name} in TableRegister")
    {:noreply, {workers, refs}}
  end
end
