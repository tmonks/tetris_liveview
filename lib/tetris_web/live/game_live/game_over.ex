defmodule TetrisWeb.GameLive.GameOver do
  use TetrisWeb, :live_view

  alias Tetris.Scores
  alias Tetris.Scores.Score

  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(score: params["score"])
     |> assign(score_changeset: Scores.change_score(%Score{}))
     |> assign(top_scores: Scores.list_top_scores(10))}
  end

  def render(assigns) do
    ~H"""
      <section class="phx-hero">
        <div>
          <h1>Game Over!</h1>
          <h2>Your score: <%= @score %></h2>
          <div>
            <.form for={@score_changeset} let={f} phx-submit="save_score">
              Enter your name: <%= text_input f, :player %>
              <br />
              <%= submit "Save" %>
            </.form>
          </div>
          <h2>Top scores:</h2>
          <%= for score <- @top_scores do %>
            <p><%= "#{score.player} - #{score.value}" %></p>
          <% end %>
          <button phx-click="play">Play Again</button>
        </div>
      </section>
    """
  end

  defp play(socket) do
    push_redirect(socket, to: Routes.game_playing_path(socket, :playing))
  end

  def handle_event("play", __data, socket) do
    {:noreply, play(socket)}
  end

  def handle_event("save_score", %{"score" => attrs}, socket) do
    {:ok, _score} =
      attrs
      |> Map.put("value", socket.assigns.score)
      |> Scores.create_score()

    top_scores = Scores.list_top_scores(10)
    {:noreply, assign(socket, :top_scores, top_scores)}
  end
end
