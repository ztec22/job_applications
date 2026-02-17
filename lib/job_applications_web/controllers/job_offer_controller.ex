defmodule JobApplicationsWeb.JobOfferController do
  use JobApplicationsWeb, :controller

  alias JobApplications.JobOffers
  alias JobApplications.JobOffers.JobOffer

  def upload_file(conn, params) do

    file = params["excel_file"]
    {:ok, package} = XlsxReader.open(file.path)

    sheet_name = Enum.at(XlsxReader.sheet_names(package), 0)
    {:ok, rows} = XlsxReader.sheet(package, sheet_name)

    [_first | records] = rows

    Enum.each(records, fn record ->
      job_offer_params = %{
        "application_date" => Enum.at(record, 0),
        "company" => Enum.at(record, 2),
        "job_title" => Enum.at(record, 3),
        "working_model" => Enum.at(record, 4),
        "sector" => Enum.at(record, 5),
        "job_description" => Enum.at(record, 6),
        "experience" => Enum.at(record, 7),
        "salary_range" => "?",
        "requested_salary" => Enum.at(record, 8),
        "status" => "?",
        "response_date" => nil,
        "response" => Enum.at(record, 9),
        "observation" => ""
      }

      if job_offer_params["application_date"] && job_offer_params["company"] && job_offer_params["job_title"] do

        case JobOffers.create_job_offer(job_offer_params) do
          {:error, %Ecto.Changeset{} = changeset} ->
            IO.puts("Invalid record #{changeset}")
          _ -> nil
        end
      end


    end)

    conn
    |> put_flash(:info, "Excel file loaded successfully.")
    |> redirect(to: ~p"/job_offers")
  end

  def index(conn, _params) do
    job_offers = JobOffers.list_job_offers()
    render(conn, :index, job_offers: job_offers)
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
