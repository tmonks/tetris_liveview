defmodule TetrisWeb.GameLive.GameOver do
  use TetrisWeb, :live_view

  alias Tetris.Scores

  def mount(params, _session, socket) do
    score = Scores.get_score!(params["score"])

    {:ok,
     socket
     |> assign(score: score)
     |> assign(score_changeset: Scores.change_score(score))
     |> assign(top_scores: Scores.list_top_scores(10))}
  end

  def render(assigns) do
    ~H"""
      <section class="phx-hero">
        <div>
          <h1 style="padding-bottom: 2em">GAME OVER</h1>
          <h2>Congratulations, you have a new high score!</h2>
          <%= if new_high_score?(@score, @top_scores) do %>
            <div style="padding-bottom: 2em">
              <.form for={@score_changeset} let={f} phx-submit="save_score">
                Enter your name: <%= text_input f, :player %>
                <%= submit "Save" %>
              </.form>
            </div>
          <% end %>
          <div style="padding-bottom: 2em;">
            <h2>Top 10</h2>
            <%= for {score, index} <- Enum.with_index(@top_scores) do %>
              <%= if score == @score do %>
                <p><%= "#{index + 1} - #{score.value} - #{score.player}" %></p>
              <% else %>
                <p style="color: red"><%= "#{index + 1} - #{score.value} - #{score.player}" %></p>
              <% end %>
            <% end %>
          </div>
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

  defp new_high_score?(score, top_scores) do
    score in top_scores
  end
end
