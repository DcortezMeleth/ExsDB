defmodule Table.Supervisor do
  use DynamicSupervisor

  def start_link do
    DynamicSupervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def create_table(table_name) do
    spec = %{id: Table.Worker, restart: :transient, start: {Table.Worker, :start_link, [table_name]}}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  # def delete_table(table_name) do
  #   DynamicSupervisor.terminate_child(__MODULE__, )
  # end

  def init(_) do
      DynamicSupervisor.init(strategy: :one_for_one)
      # We can add default arg here (i.e. schema / db name)
      # extra_arguments: [schema_name]
  end
end
