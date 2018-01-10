defmodule Ycombinator.Api.Http do
  @moduledoc """
  Api of ycombinator
  """

  @behaviour Ycombinator.Api

  @max_item_url "https://hacker-news.firebaseio.com/v0/maxitem.json"
  @item_url "https://hacker-news.firebaseio.com/v0/item/:id.json"

  def get_last_id do
    %HTTPotion.Response{
      body: body, status_code: 200
    } = HTTPotion.get @max_item_url

    elem(Integer.parse(body), 0)
  end

  def get_item(id: id) do
    %HTTPotion.Response{
      body: body, status_code: 200
    } = HTTPotion.get(String.replace(@item_url, ":id", Integer.to_string(id)))

    Poison.decode!(body, as: %Ycombinator.Api.Item{})
  end
end
