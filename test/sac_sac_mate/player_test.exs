defmodule SacSacMate.PlayerTest do
  use SacSacMate.DataCase

  alias SacSacMate.Player

  describe "ratings" do
    alias SacSacMate.Player.Rating

    @valid_attrs %{blitz_ranking: 42, date: ~D[2010-04-17], player_id: 42, rapid_ranking: 42, standard_rating: 42}
    @update_attrs %{blitz_ranking: 43, date: ~D[2011-05-18], player_id: 43, rapid_ranking: 43, standard_rating: 43}
    @invalid_attrs %{blitz_ranking: nil, date: nil, player_id: nil, rapid_ranking: nil, standard_rating: nil}

    def rating_fixture(attrs \\ %{}) do
      {:ok, rating} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Player.create_rating()

      rating
    end

    test "paginate_ratings/1 returns paginated list of ratings" do
      for _ <- 1..20 do
        rating_fixture()
      end

      {:ok, %{ratings: ratings} = page} = Player.paginate_ratings(%{})

      assert length(ratings) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_ratings/0 returns all ratings" do
      rating = rating_fixture()
      assert Player.list_ratings() == [rating]
    end

    test "get_rating!/1 returns the rating with given id" do
      rating = rating_fixture()
      assert Player.get_rating!(rating.id) == rating
    end

    test "create_rating/1 with valid data creates a rating" do
      assert {:ok, %Rating{} = rating} = Player.create_rating(@valid_attrs)
      assert rating.blitz_ranking == 42
      assert rating.date == ~D[2010-04-17]
      assert rating.player_id == 42
      assert rating.rapid_ranking == 42
      assert rating.standard_rating == 42
    end

    test "create_rating/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Player.create_rating(@invalid_attrs)
    end

    test "update_rating/2 with valid data updates the rating" do
      rating = rating_fixture()
      assert {:ok, rating} = Player.update_rating(rating, @update_attrs)
      assert %Rating{} = rating
      assert rating.blitz_ranking == 43
      assert rating.date == ~D[2011-05-18]
      assert rating.player_id == 43
      assert rating.rapid_ranking == 43
      assert rating.standard_rating == 43
    end

    test "update_rating/2 with invalid data returns error changeset" do
      rating = rating_fixture()
      assert {:error, %Ecto.Changeset{}} = Player.update_rating(rating, @invalid_attrs)
      assert rating == Player.get_rating!(rating.id)
    end

    test "delete_rating/1 deletes the rating" do
      rating = rating_fixture()
      assert {:ok, %Rating{}} = Player.delete_rating(rating)
      assert_raise Ecto.NoResultsError, fn -> Player.get_rating!(rating.id) end
    end

    test "change_rating/1 returns a rating changeset" do
      rating = rating_fixture()
      assert %Ecto.Changeset{} = Player.change_rating(rating)
    end
  end
end
