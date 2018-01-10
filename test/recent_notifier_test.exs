defmodule RecentNotifierTest do
  use ExUnit.Case
  alias Ycombinator.RecentNotifier, as: RecentNotifier

  defmodule TestSubscriber do
    @behaviour Ycombinator.RecentNotifier.Subscriber

    def new_item(%Ycombinator.Api.Item{id: id}) do
      send :test, id
    end
  end

  setup do
    Process.register self(), :test
    {:ok, expected_state: %{
      subscribers: [TestSubscriber], frequency: 0, last_id: 100
    }}
  end

  test "init", %{expected_state: expected_state} do
    assert RecentNotifier.init(%{
      subscribers: [TestSubscriber],
      frequency: 0
    }) == {:ok, expected_state}

    assert_received 100
  end

  test "perform", %{expected_state: expected_state} do
    assert RecentNotifier.handle_info(:perform, %{
      subscribers: [TestSubscriber],
      last_id: 98,
      frequency: 0
    }) == {:noreply,  expected_state}

    assert_received 99
    assert_received 100
  end
end
