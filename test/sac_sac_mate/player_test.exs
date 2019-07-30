defmodule SacSacMate.PlayerTest do
  import SacSacMate.Factory

  use SacSacMate.DataCase
  alias SacSacMate.Player

  describe "ratings" do
    alias SacSacMate.Player.Rating

    @valid_attrs %{
      blitz_rating: 42,
      date: ~D[2010-04-17],
      rapid_rating: 42,
      standard_rating: 42
    }
    @update_attrs %{
      blitz_rating: 43,
      date: ~D[2011-05-18],
      rapid_rating: 43,
      standard_rating: 43
    }
    @invalid_attrs %{
      blitz_rating: nil,
      date: nil,
      rapid_rating: nil,
      standard_rating: nil
    }

    def rating_fixture(attrs \\ %{}) do
      insert(:rating)
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
      player = insert(:player)

      assert {:ok, %Rating{} = rating} = Player.create_rating(Map.put(@valid_attrs, :player_id, player.id))
      assert rating.blitz_rating == 42
      assert rating.date == ~D[2010-04-17]
      assert rating.player_id == player.id
      assert rating.rapid_rating == 42
      assert rating.standard_rating == 42
    end

    test "create_rating/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Player.create_rating(@invalid_attrs)
    end

    test "update_rating/2 with valid data updates the rating" do
      rating = rating_fixture()
      player = insert(:player)

      assert {:ok, rating} = Player.update_rating(rating, Map.put(@update_attrs, :player_id, player.id))
      assert %Rating{} = rating
      assert rating.blitz_rating == 43
      assert rating.date == ~D[2011-05-18]
      assert rating.player_id == player.id
      assert rating.rapid_rating == 43
      assert rating.standard_rating == 43
    end

    test "update_rating/2 with invalid data returns error changeset" do
      rating = rating_fixture()
      player = insert(:player)

      assert {:error, %Ecto.Changeset{}} = Player.update_rating(rating, Map.put(@invalid_attrs, :player_id, player.id))
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
