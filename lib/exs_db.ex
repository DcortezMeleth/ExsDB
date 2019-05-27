defmodule ExsDB do
  use Application

  require Logger

  def start(_type, _args) do
    Logger.debug("App started!")

    # INIT hierarchy
    StorageSupervisor.start_link(name: StorageSupervisor)

    Registry.start_link(keys: :unique, name: Table.Registery)
    Table.Supervisor.start_link
  end

  def stop(_state) do
    Logger.error("App stoped!")
  end
end
