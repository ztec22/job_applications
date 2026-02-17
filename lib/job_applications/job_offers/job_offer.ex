defmodule JobApplications.JobOffers.JobOffer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "job_offers" do
    field :application_date, :date
    field :company, :string
    field :job_title, :string
    field :working_model, :string
    field :job_description, :string
    field :sector, :string
    field :experience, :string
    field :salary_range, :string
    field :requested_salary, :integer
    field :status, :string
    field :response_date, :date
    field :response, :string
    field :observation, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(job_offer, attrs) do
    job_offer
    |> cast(attrs, [:application_date, :company, :job_title, :working_model, :job_description, :sector, :experience, :salary_range, :requested_salary, :status, :response_date, :response, :observation])
    |> validate_required([:application_date, :company, :job_title, :working_model, :job_description, :sector, :experience, :salary_range, :requested_salary, :status, :response_date, :response, :observation])
  end
end
