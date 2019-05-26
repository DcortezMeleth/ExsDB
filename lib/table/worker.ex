defmodule Table.Worker do
  use GenServer

  require Logger

  # Client API
  @spec start_link(any()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(table_name) do
    GenServer.start_link(__MODULE__, table_name, name: via_touple(table_name))
  end

  def get_name(table_name) do
    GenServer.call(via_touple(table_name), :get_name)
  end

  def delete(table_name) do
    GenServer.stop(via_touple(table_name))
  end

  defp via_touple(name) do
    {:via, :gproc, {:n, :l ,{:table_worker, name}}}
  end

  # Server callbacks
  def init(table_name) when is_bitstring(table_name) do
    {:ok, table_name}
  end

  def handle_call(:get_name, _from, table_name) do
    {:reply, table_name, table_name}
  end
end
