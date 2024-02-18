defmodule MultiTenant.Jobs.Counter do
  @moduledoc """
  This worker periodically counts Notes and Todos
  """
  use Oban.Worker, unique: [states: [:executing]], queue: :default

  require Logger
  alias MultiTenant.Notes
  alias MultiTenant.Todos

  @impl Oban.Worker
  def perform(%Oban.Job{} = job) do
    Logger.warning(
      "There are #{Notes.list() |> length()} notes and #{Todos.list() |> length()} todos."
    )
  end
end
