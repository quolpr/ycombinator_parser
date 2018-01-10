defmodule Ycombinator do
  use Application

  alias Ycombinator.RecentNotifier
  @moduledoc false

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(RecentNotifier, [%{subscribers: [Ycombinator.ItemSubscriber]}])
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
