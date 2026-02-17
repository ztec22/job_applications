defmodule JobApplicationsWeb.ErrorJSONTest do
  use JobApplicationsWeb.ConnCase, async: true

  test "renders 404" do
    assert JobApplicationsWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert JobApplicationsWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
