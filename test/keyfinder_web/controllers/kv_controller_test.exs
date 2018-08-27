defmodule Keyfinder.KvControllerTest do
  use KeyfinderWeb.ConnCase

  describe "Test insert and lookup" do
    test "Check successful case", %{conn: conn} do
      conn = post(conn, "/insert", %{key: "John", value: "apples"})
      json_response(conn, 200)
      conn = get(conn, "/lookup/John")
      response = json_response(conn, 200)
      assert response["value"] == "apples"
    end

    test "Try to insert one key twice, value should not change", %{conn: conn} do
      conn = conn
      |> post("/insert", %{key: "John", value: "apples"})
      |> post("/insert", %{key: "John", value: "peas"})
      |> get("/lookup/John")

      response = json_response(conn, 200)
      assert response["value"] == "apples"
    end
  end
end
