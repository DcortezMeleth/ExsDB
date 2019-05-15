defmodule SessionStorage do
  use GenServer

  require DateTime
  require Logger

  # Server callbacks
  def init(:ok) do
    {:ok, %{}}
  end

  def connect(session_storage, username) do
    GenServer.call(session_storage, {:connect, username})
  end

  def disconnect(session_storage, username) do
    GenServer.call(session_storage, {:disconnect, username})
  end

  def list_sessions(session_storage) do
    GenServer.call(session_storage, :get_sessions)
  end

  # Client API
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def handle_call({:connect, username}, _from, sessions) do
    if(Map.has_key?(sessions, username)) do
      {:reply, {:error, "Session for #{username} already exists"}, sessions}
    else
      Logger.debug("Creating session for #{username}")
      {:reply, :ok, Map.put(sessions, username, DateTime.utc_now)}
    end
  end

  def handle_call({:disconnect, username}, _from, sessions) do
    if(Map.has_key?(sessions, username)) do
      {:reply, :ok, Map.delete(sessions, username)}
    else
      Logger.debug("Killing session for #{username}")
      {:reply, {:error, "Session for #{username} does not exist"}, sessions}
    end
  end

  def handle_call(:get_sessions, _from, sessions) do
    {:reply, sessions, sessions}
  end
end
