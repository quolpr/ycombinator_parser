defmodule Ycombinator.Api.Memory do
  @moduledoc """
  Api of ycombinator, for test
  """

  @behaviour Ycombinator.Api

  def get_last_id do
    100
  end

  def get_item(id: id) do
    %Ycombinator.Api.Item{
      id: id, text: "text", time: 123, title: "test", type: "story", url: ""
    }
  end
end
