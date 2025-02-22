defmodule LivePicture.Pictures.Picture do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:name, :path, :model, :upload_status]

  schema "pictures" do
    field(:name, :string)
    field(:path, :string)
    field(:model, :string)
    field(:upload_status, Ecto.Enum, values: [:uploading, :uploaded])

    timestamps(type: :utc_datetime)
  end

  def create_changeset(picture, attrs \\ %{}) do
    inserted_at = DateTime.utc_now()

    picture
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> put_change(:id, Ecto.UUID.generate())
    |> put_change(:inserted_at, inserted_at)
    |> put_change(:updated_at, inserted_at)
  end

  def changeset(picture, attrs) do
    picture
    |> cast(attrs, @required_fields)
    |> validate_required([:id, :path, :model])
  end
end
