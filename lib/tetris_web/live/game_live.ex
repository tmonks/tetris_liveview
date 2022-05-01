defmodule TetrisWeb.GameLive do
  use TetrisWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, :hello, :world)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <section class="phx-hero">
      <h1><%= "something interesting" %></h1>
    </section>
    """
  end
end
