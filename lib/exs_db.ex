defmodule ExsDB do
  @defaults %{port: 9999}

  @doc """
  Starts db. You can pass params which can replace defaults.

  ## Examples

      iex> ExsDB.start()
      {:ok, 9999}

      iex> ExsDB.start(%{port: 7777})
      {:ok, 7777}

  """
  def start(params \\ %{}) do
    %{port: port} = Map.merge(@defaults, params)
    {:ok, port}
  end
end
