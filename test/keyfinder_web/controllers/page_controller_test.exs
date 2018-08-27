defmodule KeyfinderWeb.KvControllerTest do
  use KeyfinderWeb.ConnCase

  test "Get main page", %{conn: conn} do
    conn = get(conn, "/")

    assert html_response(conn, 200) =~ "<input type=\"text\" id=\"Key\" class=\"form-control\""
    assert html_response(conn, 200) =~ "<input type=\"text\" id=\"Value\" class=\"form-control\""
    assert html_response(conn, 200) =~ "<input type=\"button\" id=\"Store\" class=\"w3-button w3-black\" value=\"Store\">"
  end

  test "Get lookup page", %{conn: conn} do
    conn = get(conn, "/lookup")

    assert html_response(conn, 200) =~ "<input type=\"text\" id=\"key\" class=\"form-control\" placeholder=\"key\" autofocus>"
    assert html_response(conn, 200) =~ "<input type=\"button\" id=\"Lookup\" class=\"w3-button w3-black\" value=\"Lookup\">"
  end
end
