defmodule Keyfinder.Repo.Migrations.CreateKeystore do
  use Ecto.Migration

  def change do
    create table(:keystore, primary_key: false) do
      add :key, :string, primary_key: true
      add :value, :string
    end
  end
end
