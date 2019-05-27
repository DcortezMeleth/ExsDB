defmodule Table.Worker do

  # Client API
  @spec start_link(any()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(table_name) do
    GenServer.start_link(Table.Worker.Server, table_name, name: via_touple(table_name))
  end

  def get_name(table_name) do
    GenServer.call(via_touple(table_name), :get_name)
  end

  def delete(table_name) do
    GenServer.stop(via_touple(table_name))
  end

  defp via_touple(name) do
    {:via, Registry, {Table.Registery, name}}
  end
end
