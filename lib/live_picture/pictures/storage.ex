defmodule LivePicture.Pictures.Storage do
  @moduledoc false

  use GenServer
  require Logger

  ### ==========================================================================
  ### GenServer Callbacks
  ### ==========================================================================
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

  def handle_call({:update_data, data, fields}, _from, state) do
    current_data = get!(data.id)

    updated_data =
      fields
      |> Enum.reduce(current_data, fn field, acc ->
        value = Map.get(data, field)
        Map.put(acc, field, value)
      end)

    :ets.insert(__MODULE__, {updated_data.id, updated_data})

    {:reply, {:ok, updated_data}, state}
  end

  ### ==========================================================================
  ### Public APIs
  ### ==========================================================================
  def insert(data) do
    GenServer.call(__MODULE__, {:add_data, data})
  end

  def update(data, fields) do
    GenServer.call(__MODULE__, {:update_data, data, fields})
  end

  def get(id) do
    case :ets.lookup(__MODULE__, id) do
      [{_, value}] -> {:ok, value}
      _ -> {:error, :not_found}
    end
  end

  def get!(id) do
    {:ok, data} = get(id)
    data
  end

  def all do
    case :ets.tab2list(__MODULE__) do
      [] -> []
      list -> Enum.map(list, fn {_id, elem} -> elem end)
    end
  end

  ### ==========================================================================
  ### Private Functions
  ### ==========================================================================
end
