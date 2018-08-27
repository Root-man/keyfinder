defmodule Keyfinder.KvDb do
  use Ecto.Schema

  import Ecto.Changeset
  
  alias Keyfinder.Repo

  # DB functions
  @primary_key {:key, :string, autogenerate: false}
  schema "keystore" do
    field(:value, :string)
  end

  def changeset(keystore, attrs \\ %{}) do
    keystore
    |> cast(attrs, [:key, :value])
    |> validate_required([:key, :value])
  end

  @spec all() :: [struct()]
  def all() do
    Repo.all(__MODULE__)
  end

  @spec insert(String.t(), String.t()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def insert(key, value) do
    changeset(%__MODULE__{key: key, value: value})
    |> Repo.insert()
  end
end
