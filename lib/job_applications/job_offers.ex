defmodule JobApplications.JobOffers do
  @moduledoc """
  The JobOffers context.
  """

  import Ecto.Query, warn: false
  alias JobApplications.Repo

  alias JobApplications.JobOffers.JobOffer
  alias Elixlsx.{Sheet, Workbook}

  @doc """
    List all companies in the job_offers.
  """
  def list_companies() do
    JobOffer
      |> select([j], j.company)
      |> distinct(true)
      |> Repo.all()
  end

  @doc """
    List all the job_offers.
  """
  def list_all_job_offers() do
    JobOffer
      |> order_by(asc: :application_date)
      |> Repo.all()
  end


  @doc """
  Returns the list of job_offers.

  ## Examples

      iex> list_job_offers()
      [%JobOffer{}, ...]

  """
  def list_job_offers(page \\ 1, filter) do
    page_size = 8
    offset = (page - 1) * page_size

    count = Repo.aggregate(JobOffer |> where(^apply_filters(filter)), :count, :id)
    pages = div(count, page_size)

    job_offers = JobOffer
      |> where(^apply_filters(filter))
      |> order_by(desc: :application_date)
      |> limit(^page_size)
      |> offset(^offset)
      |> Repo.all()

    {job_offers, count, pages}
  end

  def apply_filters(params) do
    Enum.reduce(params, dynamic(true), fn
      {"keyword", value}, dynamic ->
        dynamic([j], ^dynamic and (ilike(j.job_title, ^"%#{value}%") or ilike(j.job_description, ^"%#{value}%"))  )

      {"company", value}, dynamic ->
        dynamic([j], ^dynamic and ilike(j.company, ^"%#{value}%"))

      {"working_model", value}, dynamic ->
        dynamic([j], ^dynamic and ilike(j.working_model, ^"%#{value}%"))

      {"status", value}, dynamic ->
        dynamic([j], ^dynamic and ilike(j.status, ^"%#{value}%"))

      {_, _}, dynamic ->
        dynamic
    end)
  end

  @doc """
  Gets a single job_offer.

  Raises `Ecto.NoResultsError` if the Job offer does not exist.

  ## Examples

      iex> get_job_offer!(123)
      %JobOffer{}

      iex> get_job_offer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_job_offer!(id), do: Repo.get!(JobOffer, id)

  @doc """
  Creates a job_offer.

  ## Examples

      iex> create_job_offer(%{field: value})
      {:ok, %JobOffer{}}

      iex> create_job_offer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_job_offer(attrs) do
    %JobOffer{}
    |> JobOffer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a job_offer.

  ## Examples

      iex> update_job_offer(job_offer, %{field: new_value})
      {:ok, %JobOffer{}}

      iex> update_job_offer(job_offer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_job_offer(%JobOffer{} = job_offer, attrs) do
    job_offer
    |> JobOffer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a job_offer.

  ## Examples

      iex> delete_job_offer(job_offer)
      {:ok, %JobOffer{}}

      iex> delete_job_offer(job_offer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_job_offer(%JobOffer{} = job_offer) do
    Repo.delete(job_offer)
  end

  @doc """
  Deletes all job_offers.
  """
  def delete_all_job_offers() do
    Repo.delete_all(JobOffer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking job_offer changes.

  ## Examples

      iex> change_job_offer(job_offer)
      %Ecto.Changeset{data: %JobOffer{}}

  """
  def change_job_offer(%JobOffer{} = job_offer, attrs \\ %{}) do
    JobOffer.changeset(job_offer, attrs)
  end

  @doc """
    Reads the excel file and inserts records to the database
  """
  def load_excel(file) do
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
        "status" => "APPLIED",
        "response_date" => nil,
        "response" => Enum.at(record, 9),
        "observation" => ""
      }

      if job_offer_params["application_date"] != "" &&
         job_offer_params["company"] != "" && job_offer_params["job_title"] != "" do

        case create_job_offer(job_offer_params) do
          {:error, %Ecto.Changeset{} = changeset} ->
            IO.puts("Invalid record #{changeset}")
          _ -> nil
        end
      end


    end)
  end

  def create_excel(filename, job_offers) do
    records = for offer <- job_offers do

      response_date = if offer.response_date, do: Date.to_string(offer.response_date), else: ""

      [
        Date.to_string(offer.application_date),
        Calendar.strftime(offer.application_date, "%A, %d %B %Y"),
        offer.company,
        offer.job_title,
        offer.working_model,
        offer.sector,
        offer.job_description,
        offer.experience,
        offer.salary_range,
        offer.requested_salary,
        offer.status,
        response_date,
        offer.response,
        offer.observation
      ]
    end

    header = ["Application Date", "Date", "Company","Job title",
      "Working model","Sector","Job description","Experience",
      "Salary range","Requested salary", "Status", "Response date",
      "Response", "Observation"
    ]

    records = [header | records]

    sheet1 = %Sheet{
      name: "Sheet 1",
      rows: records,
      col_widths: Enum.reduce(1..length(header), %{}, fn i, acc -> Map.put(acc, i, 25) end)
    }

    workbook = %Workbook{sheets: [sheet1]}

    Elixlsx.write_to_memory(workbook, filename)
  end

end
