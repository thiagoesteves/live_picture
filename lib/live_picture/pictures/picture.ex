defmodule LivePicture.Pictures.Picture do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @type t() :: %__MODULE__{}

  @required_fields [
    :name,
    :path,
    :prediction,
    :model,
    :upload_status,
    :analysis_status,
    :duration
  ]

  @all_models [
    :alexnet,
    :convnext,
    :resnet18,
    :squeezenet,
    :vgg16,
    :densenet121,
    :efficientnet,
    :mobilenet,
    :regnet,
    :vision_transformer,
    :swin_transformer,
    :inception
  ]

  schema "pictures" do
    field(:name, :string)
    field(:path, :string)
    field(:prediction, :string, default: "-/-")
    field(:duration, :integer, default: 0)
    field(:model, Ecto.Enum, values: @all_models, default: :alexnet)
    field(:upload_status, Ecto.Enum, values: [:uploading, :uploaded])

    field(:analysis_status, Ecto.Enum,
      values: [:queued, :processing, :processed],
      default: :queued
    )

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
    |> validate_required(@required_fields)
  end
end
