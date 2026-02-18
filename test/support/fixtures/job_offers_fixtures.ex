defmodule JobApplications.JobOffersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `JobApplications.JobOffers` context.
  """

  @doc """
  Generate a job_offer.
  """
  def job_offer_fixture(attrs \\ %{}) do
    {:ok, job_offer} =
      attrs
      |> Enum.into(%{
        application_date: ~D[2026-02-16],
        company: "some company",
        experience: "some experience",
        job_description: "some job_description",
        job_title: "some job_title",
        observation: "some observation",
        requested_salary: "some requested_salary",
        response: "some response",
        response_date: ~D[2026-02-16],
        salary_range: "some salary_range",
        sector: "some sector",
        status: "some status",
        working_model: "some working_model"
      })
      |> JobApplications.JobOffers.create_job_offer()

    job_offer
  end
end
