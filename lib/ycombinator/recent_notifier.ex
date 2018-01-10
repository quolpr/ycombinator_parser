defmodule Ycombinator.RecentNotifier do
  @moduledoc """
  Request new item ids from ycombinator every @seconds
  """

  defmodule Subscriber do
    @moduledoc """
    Behaviour for subscribers
    """

    @callback new_item(Ycombinator.Api.Item.t) :: any()
  end

  use GenServer

  @frequency 1 * 1000 # in seconds
  @api Application.get_env(:ycombinator, :api)

  @typep subscribers :: [Subscriber] | []
  @typep state :: %{
    subscribers: subscribers,
    frequency: number,
    last_id: number
  }

  @spec start_link(%{subscribers: subscribers}) :: GenServer.on_start
  def start_link(args \\ %{subscribers: []}) do
    GenServer.start_link(
      __MODULE__, Map.merge(%{frequency: @frequency}, args), name: __MODULE__
    )
  end

  @spec handle_info(:perform, state) :: {:noreply, state}
  def handle_info(:perform, state) do
    new_last_id = @api.get_last_id

    perform(state.subscribers, state.last_id, new_last_id)
    schedule_work(state.frequency)

    {:noreply,  Map.merge(state, %{last_id: new_last_id})}
  end

  @spec init(%{subscribers: subscribers, frequency: number}) :: {:ok, state}
  def init(state) do
    last_id = @api.get_last_id

    perform(state.subscribers, last_id)
    schedule_work(state.frequency)

    {:ok,  Map.merge(state, %{last_id: last_id})}
  end

  @spec perform(subscribers, number, number) :: any()
  defp perform(_subscribers, last_id, new_last_id) when last_id == new_last_id, do: nil

  defp perform(subscribers, last_id, new_last_id) do
    Enum.each(last_id+1..new_last_id, fn(id) ->
      notify_subscribers(subscribers, id)
    end)
  end

  @spec perform(subscribers, number) :: any()
  defp perform(subscribers, last_id) do
    notify_subscribers(subscribers, last_id)
  end

  @spec notify_subscribers(subscribers, number) :: any()
  defp notify_subscribers(subscribers, id) do
    subscribers
    |> Enum.map(&Task.async(fn ->
         &1.new_item(@api.get_item(id: id))
       end))
    |> Enum.map(&Task.await/1)
  end

  @spec schedule_work(number) :: any()
  defp schedule_work(0), do: nil

  defp schedule_work(frequency) do
    Process.send_after(self(), :perform, frequency)
  end
end
