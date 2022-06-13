defmodule TetrisWeb.GameLive.Playing do
  use TetrisWeb, :live_view
  alias Tetris.Game

  @start_interval 500
  @end_interval 100
  @point_size 30

  def mount(_params, _session, socket) do
    if connected?(socket), do: Game.subscribe()

    socket =
      socket
      |> assign(:paused, false)
      |> assign(:point_size, @point_size)
      |> new_game()
      |> start_timer()

    {:ok, socket}
  end

  defp start_timer(socket) do
    interval = get_interval(socket.assigns.game)
    {:ok, timer} = :timer.send_interval(interval, self(), :tick)

    assign(socket, :timer, timer)
  end

  defp update_timer(socket) do
    :timer.cancel(socket.assigns.timer)
    socket |> start_timer()
  end

  defp render_board(assigns) do
    ~H"""
    <svg width={10 * @point_size} height={20 * @point_size}>
      <rect width={10 * @point_size} height={20 * @point_size} style="fill:rgb(0,0,0);" />
      <%= render_points(assigns) %>
    </svg>
    """
  end

  def render_points(assigns) do
    ~H"""
      <%= for {x, y, shape} <- @game.points ++ Game.junkyard_points(@game) do %>
        <rect
          width={@point_size} height={@point_size}
          x={(x-1) * @point_size} y={(y-1) * @point_size}
          style={"fill:#{color(shape)}"} />
      <% end %>
    """
  end

  defp color(:l), do: "orange"
  defp color(:j), do: "blue"
  defp color(:s), do: "limegreen"
  defp color(:z), do: "red"
  defp color(:o), do: "yellow"
  defp color(:i), do: "aqua"
  defp color(:t), do: "purple"
  defp color(_), do: "red"

  defp new_game(socket) do
    assign(socket, game: Game.new())
  end

  def rotate(%{assigns: %{game: game}} = socket) do
    socket
    |> assign(:game, Game.rotate(game))
  end

  def down(%{assigns: %{game: game}} = socket) do
    socket
    |> assign(:game, Game.down(game))
  end

  def right(%{assigns: %{game: game}} = socket) do
    socket
    |> assign(:game, Game.right(game))
  end

  def left(%{assigns: %{game: game}} = socket) do
    socket
    |> assign(:game, Game.left(game))
  end

  def handle_info(:tick, socket) do
    {:noreply,
     socket
     |> down()
     |> maybe_end_game()}
  end

  def handle_info({:level_up, _level}, socket) do
    {:noreply, socket |> update_timer()}
  end

  def handle_event("keystroke", %{"key" => " "}, socket) do
    {:noreply, socket |> rotate()}
  end

  def handle_event("keystroke", %{"key" => "ArrowDown"}, socket) do
    {:noreply, socket |> down()}
  end

  def handle_event("keystroke", %{"key" => "ArrowRight"}, socket) do
    {:noreply, socket |> right()}
  end

  def handle_event("keystroke", %{"key" => "ArrowLeft"}, socket) do
    {:noreply, socket |> left()}
  end

  def handle_event("keystroke", %{"key" => "p"}, socket) do
    socket =
      if socket.assigns.paused do
        interval = get_interval(socket.assigns.game)
        {:ok, timer} = :timer.send_interval(interval, self(), :tick)
        assign(socket, timer: timer, paused: false)
      else
        :timer.cancel(socket.assigns.timer)
        assign(socket, timer: nil, paused: true)
      end

    {:noreply, socket}
  end

  def handle_event("keystroke", _, socket) do
    {:noreply, socket}
  end

  defp maybe_end_game(%{assigns: %{game: %{game_over: true, score: score}}} = socket) do
    push_redirect(socket, to: Routes.game_game_over_path(socket, :game_over, score: score))
  end

  defp maybe_end_game(socket) do
    socket
  end

  def get_interval(game) do
    increment = (@start_interval - @end_interval) / 9
    (@start_interval - (game.level - 1) * increment) |> round()
  end
end
