defmodule Tables.TableWorker do
  use GenServer

  require Logger

  # Client API
  def start_link(table_name, opts) do
    GenServer.start_link(__MODULE__, table_name, opts)
  end

  def get_name(pid) do
    GenServer.call(pid, :get_name)
  end

  # Server callbacks
  def init(table_name) when is_bitstring(table_name) do
    {:ok, table_name}
  end

  def handle_call(:get_name, _from, table_name) do
    {:reply, table_name, table_name}
  end
end
