defmodule JobApplicationsWeb.JobOfferHTML do
  use JobApplicationsWeb, :html

  embed_templates "job_offer_html/*"

  @doc """
  Renders a job_offer form.

  The form is defined in the template at
  job_offer_html/job_offer_form.html.heex
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :return_to, :string, default: nil

  def job_offer_form(assigns)
end
