defmodule MultiTenant.Jobs.Counter do
  @moduledoc """
  This worker periodically counts Notes and Todos.  Mostly just to show that OBAN is working.
  """
  use Oban.Worker, unique: [states: [:executing]], queue: :default

  require Logger
  alias MultiTenant.Notes
  alias MultiTenant.Todos

  @impl Oban.Worker
  def perform(%Oban.Job{}) do
    # This job doesn't run within the context of a specific tenant.
    Logger.warning(
      "There are #{Notes.list() |> length()} notes and #{Todos.list_all() |> length()} todos."
    )
  end
end
