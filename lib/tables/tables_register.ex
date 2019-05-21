defmodule Tables.TablesRegister do
  use GenServer

  require DateTime
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

  # def delete(table_name) do
  #   GenServer.call(TablesRegister, {:delete, table_name})
  # end

  # Server callbacks
  def init(tables) when is_list(tables) do
    workers = tables
              |> Enum.reduce(%{}, fn table_name, acc ->
                Map.put(acc, table_name, Tables.TableWorker.start_link(table_name, []) |> elem(1))
              end)

    refs = workers
    |> Map.to_list
    |> Enum.reduce(%{}, fn {table_name, pid}, acc ->
      Map.put(acc, Process.monitor(pid), table_name)
          end)

    Logger.debug("Workers: #{inspect workers}")
    Logger.debug("Refs: #{inspect refs}")
    Logger.debug("Result: #{inspect {workers, refs}}}")
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
      {:ok, worker} = Tables.TableWorker.start_link(table_name, [])
      ref = Process.monitor(worker)
      workers = Map.put(workers, table_name, worker)
      refs = Map.put(refs, table_name, ref)
      {:reply, :ok, {workers, refs}}
    end
  end

  # Shouldn't be necessary while we have monitor
  # def handle_call({:delete, table_name}, _from, {workers, _}) do
  #   if(Map.has_key?(workers, table_name)) do
  #     # Shouldnt it be killed?
  #     {:reply, :ok, Map.delete(workers, table_name)}
  #   else
  #     Logger.debug("Killing session for #{table_name}")
  #     {:reply, {:error, "Session for #{table_name} does not exist"}, workers}
  #   end
  # end

  def handle_info({:DOWN, ref, :process, _pid, _reason}, {workers, refs}) do
      {table_name, refs} = Map.pop(refs, ref)
      workers = Map.delete(workers, table_name)
      {:noreply, {workers, refs}}
  end
end
