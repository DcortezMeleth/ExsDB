defmodule Table.Worker.Server do
  use GenServer

  # Server callbacks
  def init(table_name) when is_bitstring(table_name) do
    {:ok, table_name}
  end

  def handle_call(:get_name, _from, table_name) do
    {:reply, table_name, table_name}
  end
end
