defmodule ExsDB do
  use Application

  require Logger

  def start(_type, _args) do
    Logger.debug("App started!")
    # IO.puts "App started!"
    StorageSupervisor.start_link(name: StorageSupervisor)
  end

  def stop(_state) do
    Logger.error("App stoped!")
    # IO.puts "App stoped!"
  end
end
