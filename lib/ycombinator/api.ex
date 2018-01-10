defmodule Ycombinator.Api do
  @moduledoc """
  Api of ycombinator
  """

  defmodule Item do
    @moduledoc false

    @derive [Poison.Encoder]
    @type t :: %Item{
      id: number,
      title: String.t,
      time: number,
      text: String.t,
      type: String.t,
      url: String.t
    }
    defstruct [:id, :title, :time, :text, :type, :url]
  end

  @callback get_last_id() :: number
  @callback get_item(id: number) :: Item.t
end
