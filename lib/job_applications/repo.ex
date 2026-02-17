defmodule JobApplications.Repo do
  use Ecto.Repo,
    otp_app: :job_applications,
    adapter: Ecto.Adapters.Postgres
end
