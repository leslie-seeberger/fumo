defmodule FumoWeb.DeckControllerTest do
  use FumoWeb.ConnCase

  @create_attrs %{description: "some description", is_published: false, title: "some title"}
  @update_attrs %{description: "some updated description", is_published: false, title: "some updated title"}
  @invalid_attrs %{description: nil, is_published: nil, title: nil}

 describe "index" do
    test "lists all decks", %{conn: conn} do
      conn = get(conn, Routes.deck_path(conn, :index))
      assert html_response(conn, 200) =~ "All Decks</h1>"
    end
  end

  describe "new deck" do
    setup [:login_user]
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.deck_path(conn, :new))
      assert html_response(conn, 200) =~ "New Deck"
    end
  end

  describe "create deck" do
    setup [:login_user]
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.deck_path(conn, :create), deck: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.deck_path(conn, :show, id)

      conn = get(conn, Routes.deck_path(conn, :show, id))
      assert html_response(conn, 200) =~ "#{@create_attrs.title}</h1>"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.deck_path(conn, :create), deck: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Deck"
    end
  end

  describe "edit deck" do
    setup [:login_user, :create_deck]

    test "renders form for editing chosen deck", %{conn: conn, deck: deck} do
      conn = get(conn, Routes.deck_path(conn, :edit, deck))
      assert html_response(conn, 200) =~ "Edit Deck"
    end
  end

  describe "update deck" do
    setup [:login_user, :create_deck]

    test "redirects when data is valid", %{conn: conn, deck: deck} do
      conn = put(conn, Routes.deck_path(conn, :update, deck), deck: @update_attrs)
      assert redirected_to(conn) == Routes.deck_path(conn, :show, deck)

      conn = get(conn, Routes.deck_path(conn, :show, deck))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, deck: deck} do
      conn = put(conn, Routes.deck_path(conn, :update, deck), deck: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Deck"
    end
  end

  describe "delete deck" do
    setup [:login_user, :create_deck]

    test "deletes chosen deck", %{conn: conn, deck: deck} do
      conn = delete(conn, Routes.deck_path(conn, :delete, deck))
      assert redirected_to(conn) == Routes.deck_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.deck_path(conn, :show, deck))
      end
    end
  end

  defp login_user(conn) do
    register_and_log_in_user(conn)
  end

  defp create_deck(conn) do
    deck = insert(:deck, user: conn.user)

    %{deck: deck}
  end
end
