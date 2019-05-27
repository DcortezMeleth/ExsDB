defmodule Table.Worker do

  # Client API
  def start_link(table_name, columns) do
    GenServer.start_link(Table.Worker.Server, {table_name, columns}, name: via_touple(table_name))
  end

  def get_name(table_name) do
    GenServer.call(via_touple(table_name), :get_name)
  end

  def get_columns(table_name) do
    GenServer.call(via_touple(table_name), :get_columns)
  end

  def delete(table_name) do
    GenServer.stop(via_touple(table_name))
  end

  defp via_touple(name) do
    {:via, Registry, {Table.Registery, name}}
  end
end
