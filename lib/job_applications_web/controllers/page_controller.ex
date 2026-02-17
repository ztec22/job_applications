defmodule JobApplicationsWeb.PageController do
  use JobApplicationsWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
