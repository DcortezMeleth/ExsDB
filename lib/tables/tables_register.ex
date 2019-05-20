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

  def delete(table_name) do
    GenServer.call(TablesRegister, {:delete, table_name})
  end

  # Server callbacks
  def init(tables) when is_list(tables) do
    workers = tables
              |> Enum.reduce(%{}, fn x, acc ->
                Map.put(acc, x, Tables.TableWorker.start_link(x, []))
              end)
    {:ok, workers}
  end

  def handle_call({:lookup, table_name}, _from, workers) do
    if(Map.has_key?(workers, table_name)) do
      {:reply, Map.fetch(workers, table_name), workers}
    else
      Logger.debug("Worker for table '#{table_name}' does not exist")
      {:reply, {:error, "Worker for table '#{table_name}' does not exist"}, workers}
      # TODO: create some func to not duplicate error msg
    end
  end

  def handle_call({:create, table_name}, _from, workers) do
    if(Map.has_key?(workers, table_name)) do
      {:reply, {:error, "Worker for table '#{table_name}' already exists"}, workers}
      Logger.debug("Worker for table '#{table_name}' already exists")
    else
      {:ok, worker} = Tables.TableWorker.start_link(table_name, [])
      {:reply, :ok, Map.put(workers, table_name, worker)}
    end
  end

  def handle_call({:delete, table_name}, _from, workers) do
    if(Map.has_key?(workers, table_name)) do
      {:reply, :ok, Map.delete(workers, table_name)}
    else
      Logger.debug("Killing session for #{table_name}")
      {:reply, {:error, "Session for #{table_name} does not exist"}, workers}
    end
  end
end
