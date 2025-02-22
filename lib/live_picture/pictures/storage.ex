defmodule LivePicture.Pictures.Storage do
  @moduledoc false

  use GenServer
  require Logger

  @spec start_link(any()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    :ets.new(__MODULE__, [:set, :protected, :named_table])

    {:ok, %{}}
  end

  @impl true
  def handle_call({:add_data, data}, _from, state) do
    :ets.insert(__MODULE__, {data.id, data})

    {:reply, {:ok, data}, state}
  end

  def insert(data) do
    GenServer.call(__MODULE__, {:add_data, data})
  end

  def get(id) do
    case :ets.lookup(__MODULE__, id) do
      [{_, value}] -> {:ok, value}
      _ -> {:error, :not_found}
    end
  end

  def all do
    case :ets.tab2list(__MODULE__) do
      [] -> []
      list -> Enum.map(list, fn {_id, elem} -> elem end)
    end
  end
end
