defmodule OAuth2Cli.Manager do
  use GenServer

  alias OAuth2Cli.Strategy

  @name OAuth2Cli.Manager

  def start_link, do:
    GenServer.start_link(__MODULE__, [], name: @name)

  def register({name, params}), do:
    GenServer.call(@name, {:register, name, params})
  def register({name, params, discovery}) when is_atom(name), do:
    GenServer.call(@name, {:register, name, params, discovery})
  def register(params), do:
    register({:default, params})

  def strategy_list(), do:
    GenServer.call(@name, {:strategy_list})

  def get_strategy(name) when is_atom(name), do:
    GenServer.call(@name, {:get_strategy, name})

  #
  # GenServer Callbacks
  #
  def init([]), do: {:ok, %{strategies: HashDict.new}}

  def handle_call({:register, name, params}, _from, state) do
    case Strategy.Simple.new(params) do
      {:ok, strategy} ->
        {:reply, :ok, %{state | strategies: Dict.put(state.strategies, name, strategy)}}
      _error ->
        {:reply, :error, state}
    end
  end

  def handle_call({:register, name, params, discovery}, _from, state) do
    case Strategy.Verified.new(params, discovery) do
      {:ok, strategy} ->
        {:reply, :ok, %{state | strategies: Dict.put(state.strategies, name, strategy)}}
      _error ->
        {:reply, :error, state}
    end
  end

  def handle_call({:get_strategy, name}, _from, state) do
    try do
      {:reply, {:ok, state.strategies[name]}, state}
    rescue
      _error -> {:reply, {:error, :strategy_not_found}, state}
    end
  end

  def handle_call({:strategy_list}, _from, state) do
    {:reply, Dict.keys(state.strategies), state}
  end

end