defmodule Table.Worker.Server do
  use GenServer

  # Server callbacks
  def init({table_name, columns}) do
    {:ok, {table_name, columns}}
  end

  def handle_call(:get_name, _from, {table_name, columns}) do
    {:reply, table_name, {table_name, columns}}
  end

  def handle_call(:get_columns, _from, {table_name, columns}) do
    {:reply, columns, {table_name, columns}}
  end
end
