defmodule Tetris.ScoresTest do
  use Tetris.DataCase

  alias Tetris.Scores

  describe "scores" do
    alias Tetris.Scores.Score

    import Tetris.ScoresFixtures

    @invalid_attrs %{player: nil, value: nil}

    test "list_scores/0 returns all scores" do
      score = score_fixture()
      assert Scores.list_scores() == [score]
    end

    test "get_score!/1 returns the score with given id" do
      score = score_fixture()
      assert Scores.get_score!(score.id) == score
    end

    test "create_score/1 with valid data creates a score" do
      valid_attrs = %{player: "some player", value: 42}

      assert {:ok, %Score{} = score} = Scores.create_score(valid_attrs)
      assert score.player == "some player"
      assert score.value == 42
    end

    test "create_score/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Scores.create_score(@invalid_attrs)
    end

    test "update_score/2 with valid data updates the score" do
      score = score_fixture()
      update_attrs = %{player: "some updated player", value: 43}

      assert {:ok, %Score{} = score} = Scores.update_score(score, update_attrs)
      assert score.player == "some updated player"
      assert score.value == 43
    end

    test "update_score/2 with invalid data returns error changeset" do
      score = score_fixture()
      assert {:error, %Ecto.Changeset{}} = Scores.update_score(score, @invalid_attrs)
      assert score == Scores.get_score!(score.id)
    end

    test "delete_score/1 deletes the score" do
      score = score_fixture()
      assert {:ok, %Score{}} = Scores.delete_score(score)
      assert_raise Ecto.NoResultsError, fn -> Scores.get_score!(score.id) end
    end

    test "change_score/1 returns a score changeset" do
      score = score_fixture()
      assert %Ecto.Changeset{} = Scores.change_score(score)
    end
  end
end
