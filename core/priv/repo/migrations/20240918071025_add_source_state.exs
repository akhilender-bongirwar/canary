defmodule Canary.Repo.Migrations.AddSourceState do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    alter table(:sources) do
      add :state, :text, null: false, default: "idle"
      add :last_fetched_at, :utc_datetime
    end
  end

  def down do
    alter table(:sources) do
      remove :last_fetched_at
      remove :state
    end
  end
end
