defmodule JobApplications.JobOffersTest do
  use JobApplications.DataCase

  alias JobApplications.JobOffers

  describe "job_offers" do
    alias JobApplications.JobOffers.JobOffer

    import JobApplications.JobOffersFixtures

    @invalid_attrs %{status: nil, response: nil, application_date: nil, company: nil, job_title: nil, working_model: nil, job_description: nil, sector: nil, experience: nil, salary_range: nil, requested_salary: nil, response_date: nil, observation: nil}

    test "list_job_offers/0 returns all job_offers" do
      job_offer = job_offer_fixture()
      assert JobOffers.list_job_offers() == [job_offer]
    end

    test "get_job_offer!/1 returns the job_offer with given id" do
      job_offer = job_offer_fixture()
      assert JobOffers.get_job_offer!(job_offer.id) == job_offer
    end

    test "create_job_offer/1 with valid data creates a job_offer" do
      valid_attrs = %{status: "some status", response: "some response", application_date: ~D[2026-02-16], company: "some company", job_title: "some job_title", working_model: "some working_model", job_description: "some job_description", sector: "some sector", experience: "some experience", salary_range: "some salary_range", requested_salary: "some requested_salary", response_date: ~D[2026-02-16], observation: "some observation"}

      assert {:ok, %JobOffer{} = job_offer} = JobOffers.create_job_offer(valid_attrs)
      assert job_offer.status == "some status"
      assert job_offer.response == "some response"
      assert job_offer.application_date == ~D[2026-02-16]
      assert job_offer.company == "some company"
      assert job_offer.job_title == "some job_title"
      assert job_offer.working_model == "some working_model"
      assert job_offer.job_description == "some job_description"
      assert job_offer.sector == "some sector"
      assert job_offer.experience == "some experience"
      assert job_offer.salary_range == "some salary_range"
      assert job_offer.requested_salary == "some requested_salary"
      assert job_offer.response_date == ~D[2026-02-16]
      assert job_offer.observation == "some observation"
    end

    test "create_job_offer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = JobOffers.create_job_offer(@invalid_attrs)
    end

    test "update_job_offer/2 with valid data updates the job_offer" do
      job_offer = job_offer_fixture()
      update_attrs = %{status: "some updated status", response: "some updated response", application_date: ~D[2026-02-17], company: "some updated company", job_title: "some updated job_title", working_model: "some updated working_model", job_description: "some updated job_description", sector: "some updated sector", experience: "some updated experience", salary_range: "some updated salary_range", requested_salary: "some requested_salary", response_date: ~D[2026-02-17], observation: "some updated observation"}

      assert {:ok, %JobOffer{} = job_offer} = JobOffers.update_job_offer(job_offer, update_attrs)
      assert job_offer.status == "some updated status"
      assert job_offer.response == "some updated response"
      assert job_offer.application_date == ~D[2026-02-17]
      assert job_offer.company == "some updated company"
      assert job_offer.job_title == "some updated job_title"
      assert job_offer.working_model == "some updated working_model"
      assert job_offer.job_description == "some updated job_description"
      assert job_offer.sector == "some updated sector"
      assert job_offer.experience == "some updated experience"
      assert job_offer.salary_range == "some updated salary_range"
      assert job_offer.requested_salary == "some requested_salary"
      assert job_offer.response_date == ~D[2026-02-17]
      assert job_offer.observation == "some updated observation"
    end

    test "update_job_offer/2 with invalid data returns error changeset" do
      job_offer = job_offer_fixture()
      assert {:error, %Ecto.Changeset{}} = JobOffers.update_job_offer(job_offer, @invalid_attrs)
      assert job_offer == JobOffers.get_job_offer!(job_offer.id)
    end

    test "delete_job_offer/1 deletes the job_offer" do
      job_offer = job_offer_fixture()
      assert {:ok, %JobOffer{}} = JobOffers.delete_job_offer(job_offer)
      assert_raise Ecto.NoResultsError, fn -> JobOffers.get_job_offer!(job_offer.id) end
    end

    test "change_job_offer/1 returns a job_offer changeset" do
      job_offer = job_offer_fixture()
      assert %Ecto.Changeset{} = JobOffers.change_job_offer(job_offer)
    end
  end
end
