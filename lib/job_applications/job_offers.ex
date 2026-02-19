defmodule JobApplications.JobOffers do
  @moduledoc """
  The JobOffers context.
  """

  import Ecto.Query, warn: false
  alias JobApplications.Repo

  alias JobApplications.JobOffers.JobOffer

  @doc """
  Returns the list of job_offers.

  ## Examples

      iex> list_job_offers()
      [%JobOffer{}, ...]

  """
  def list_job_offers(page \\ 1, filter) do
    page_size = 10
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
end
