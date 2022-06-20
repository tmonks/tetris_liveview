# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Tetris.Repo.insert!(%Tetris.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule Tetris.Seeds do
  alias Tetris.Scores

  @score_count 10

  def run() do
    for _ <- 1..@score_count do
      score = %{
        value: Faker.random_between(10, 1000),
        player: Faker.Person.first_name()
      }

      {:ok, _} = Scores.create_score(score)
    end
  end
end

Tetris.Seeds.run()
