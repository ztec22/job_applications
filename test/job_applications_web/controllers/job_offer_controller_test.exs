defmodule JobApplicationsWeb.JobOfferControllerTest do
  use JobApplicationsWeb.ConnCase

  import JobApplications.JobOffersFixtures

  @create_attrs %{status: "some status", response: "some response", application_date: ~D[2026-02-16], company: "some company", job_title: "some job_title", working_model: "some working_model", job_description: "some job_description", sector: "some sector", experience: "some experience", salary_range: "some salary_range", requested_salary: 42, response_date: ~D[2026-02-16], observation: "some observation"}
  @update_attrs %{status: "some updated status", response: "some updated response", application_date: ~D[2026-02-17], company: "some updated company", job_title: "some updated job_title", working_model: "some updated working_model", job_description: "some updated job_description", sector: "some updated sector", experience: "some updated experience", salary_range: "some updated salary_range", requested_salary: 43, response_date: ~D[2026-02-17], observation: "some updated observation"}
  @invalid_attrs %{status: nil, response: nil, application_date: nil, company: nil, job_title: nil, working_model: nil, job_description: nil, sector: nil, experience: nil, salary_range: nil, requested_salary: nil, response_date: nil, observation: nil}

  describe "index" do
    test "lists all job_offers", %{conn: conn} do
      conn = get(conn, ~p"/job_offers")
      assert html_response(conn, 200) =~ "Listing Job offers"
    end
  end

  describe "new job_offer" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/job_offers/new")
      assert html_response(conn, 200) =~ "New Job offer"
    end
  end

  describe "create job_offer" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/job_offers", job_offer: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/job_offers/#{id}"

      conn = get(conn, ~p"/job_offers/#{id}")
      assert html_response(conn, 200) =~ "Job offer #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/job_offers", job_offer: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Job offer"
    end
  end

  describe "edit job_offer" do
    setup [:create_job_offer]

    test "renders form for editing chosen job_offer", %{conn: conn, job_offer: job_offer} do
      conn = get(conn, ~p"/job_offers/#{job_offer}/edit")
      assert html_response(conn, 200) =~ "Edit Job offer"
    end
  end

  describe "update job_offer" do
    setup [:create_job_offer]

    test "redirects when data is valid", %{conn: conn, job_offer: job_offer} do
      conn = put(conn, ~p"/job_offers/#{job_offer}", job_offer: @update_attrs)
      assert redirected_to(conn) == ~p"/job_offers/#{job_offer}"

      conn = get(conn, ~p"/job_offers/#{job_offer}")
      assert html_response(conn, 200) =~ "some updated company"
    end

    test "renders errors when data is invalid", %{conn: conn, job_offer: job_offer} do
      conn = put(conn, ~p"/job_offers/#{job_offer}", job_offer: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Job offer"
    end
  end

  describe "delete job_offer" do
    setup [:create_job_offer]

    test "deletes chosen job_offer", %{conn: conn, job_offer: job_offer} do
      conn = delete(conn, ~p"/job_offers/#{job_offer}")
      assert redirected_to(conn) == ~p"/job_offers"

      assert_error_sent 404, fn ->
        get(conn, ~p"/job_offers/#{job_offer}")
      end
    end
  end

  defp create_job_offer(_) do
    job_offer = job_offer_fixture()

    %{job_offer: job_offer}
  end
end
