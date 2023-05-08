defmodule PromiseWeb.UserControllerTest do
  use PromiseWeb.ConnCase

  import Promise.AccountsFixtures

  @create_attrs %{
    first_name: "some-first-name",
    last_name: "some-last-name",
    email: "some@email",
    password: "somepassword"
  }

  @invalid_attrs %{
    first_name: "With space",
    last_name: "With space",
    email: "wrong_email",
    password: "short"
  }

  describe "register user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @create_attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert response(conn, 401)

      conn = conn
        |> auth_user(@create_attrs)
        |> get(~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "email" => "some@email",
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "search" do
    setup [:create_user_and_auth]

    test "correctly count", %{conn: conn} do
      conn = get(conn, ~p"/api/users", name: "")
      assert json_response(conn, 200)["total_count"] == 1
    end

    test "found user by first_name", %{conn: conn} do
        # User 1
        user_fixture(first_name: "Name-one")
        # User 2
        user_fixture(first_name: "Name-two")
        # User 3 -- Target
        name = "Name-three"
        search_user = user_fixture(first_name: name)
        search_user_id = search_user.id

        # Test
        conn = get(conn, ~p"/api/users", name: name)

        response = json_response(conn, 200)

        assert %{"id" => ^search_user_id} = List.first(response["data"])
    end

    test "found user by last_name", %{conn: conn} do
      # User 1
      user_fixture(last_name: "Name-one")
      # User 2
      user_fixture(last_name: "Name-two")
      # User 3 -- Target
      name = "Name-three"
      search_user = user_fixture(last_name: name)
      search_user_id = search_user.id

      # Test
      conn = get(conn, ~p"/api/users", name: name)

      response = json_response(conn, 200)

      assert %{"id" => ^search_user_id} = List.first(response["data"])
    end
  end

  defp create_user_and_auth(%{conn: conn}) do
    user = user_fixture()
    conn = auth_user_by_password(conn, user)
    %{user: user, conn: conn}
  end
end
