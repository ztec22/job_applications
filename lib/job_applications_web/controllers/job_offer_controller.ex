defmodule JobApplicationsWeb.JobOfferController do
  use JobApplicationsWeb, :controller

  alias JobApplications.JobOffers
  alias JobApplications.JobOffers.JobOffer

  def upload_file(conn, params) do

    file = params["excel_file"]
    JobOffers.load_excel(file)

    conn
      |> put_flash(:info, "Excel file loaded successfully.")
      |> redirect(to: ~p"/job_offers")
  end

  def index(conn, params) do
    page =
      case params["page"] do
        nil -> 1
        "" -> 1
        value -> String.to_integer(value)
      end

    filter =
      params
      |> Map.get("filter", %{})
      |> Enum.reject(fn {_k, v} -> v in ["", nil] end)
      |> Map.new()

    {job_offers, count, pages} = JobOffers.list_job_offers(page, filter)
    render(conn, :index, filter: filter || %{}, job_offers: job_offers, count: count, pages: pages , current_page: page)
  end

  def new(conn, _params) do
    changeset = JobOffers.change_job_offer(%JobOffer{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"job_offer" => job_offer_params}) do
    case JobOffers.create_job_offer(job_offer_params) do
      {:ok, job_offer} ->
        conn
        |> put_flash(:info, "Job offer created successfully.")
        |> redirect(to: ~p"/job_offers/#{job_offer}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    job_offer = JobOffers.get_job_offer!(id)
    render(conn, :show, job_offer: job_offer)
  end

  def edit(conn, %{"id" => id}) do
    job_offer = JobOffers.get_job_offer!(id)
    changeset = JobOffers.change_job_offer(job_offer)
    render(conn, :edit, job_offer: job_offer, changeset: changeset)
  end

  def update(conn, %{"id" => id, "job_offer" => job_offer_params}) do
    job_offer = JobOffers.get_job_offer!(id)

    case JobOffers.update_job_offer(job_offer, job_offer_params) do
      {:ok, job_offer} ->
        conn
        |> put_flash(:info, "Job offer updated successfully.")
        |> redirect(to: ~p"/job_offers/#{job_offer}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, job_offer: job_offer, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    job_offer = JobOffers.get_job_offer!(id)
    {:ok, _job_offer} = JobOffers.delete_job_offer(job_offer)

    conn
    |> put_flash(:info, "Job offer deleted successfully.")
    |> redirect(to: ~p"/job_offers")
  end

  def delete_all(conn, _params) do
    {count, _} = JobOffers.delete_all_job_offers()

    conn
    |> put_flash(:info, "Deleted all #{count} job offers successfully.")
    |> redirect(to: ~p"/job_offers")
  end

end
