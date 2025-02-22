defmodule LivePicture.Pictures do
  @moduledoc """
  The Pictures context.
  """

  import Ecto.Query, warn: false

  alias LivePicture.Pictures.Picture
  alias LivePicture.Pictures.Storage

  @doc """
  Returns the list of pictures.

  ## Examples

      iex> list_pictures()
      [%Picture{}, ...]

  """

  def list_pictures do
    Storage.all()
  end

  @doc """
  Gets a single picture.

  Raises `Ecto.NoResultsError` if the Picture does not exist.

  ## Examples

      iex> get_picture!(123)
      {:ok, %Picture{}}

      iex> get_picture!(456)
      {:error, :not_found}

  """
  def get_picture(id), do: Storage.get(id)

  @doc """
  Creates a picture.

  ## Examples

      iex> create_picture(%{field: value})
      {:ok, %Picture{}}

      iex> create_picture(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_picture(attrs \\ %{}) do
    response =
      %Picture{}
      |> Picture.create_changeset(attrs)
      |> Ecto.Changeset.apply_action(:create)

    case response do
      {:ok, picture} ->
        Storage.insert(picture)

      res ->
        res
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking picture changes.

  ## Examples

      iex> change_picture(picture)
      %Ecto.Changeset{data: %Picture{}}

  """
  def change_picture(%Picture{} = picture, attrs \\ %{}) do
    Picture.changeset(picture, attrs)
  end
end
