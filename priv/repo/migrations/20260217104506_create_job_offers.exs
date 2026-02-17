defmodule JobApplications.Repo.Migrations.CreateJobOffers do
  use Ecto.Migration

  def change do
    create table(:job_offers) do
      add :application_date, :date
      add :company, :string
      add :job_title, :string
      add :working_model, :string
      add :job_description, :string
      add :sector, :string
      add :experience, :string
      add :salary_range, :string
      add :requested_salary, :string
      add :status, :string
      add :response_date, :date
      add :response, :string
      add :observation, :string

      timestamps(type: :utc_datetime)
    end
  end
end
