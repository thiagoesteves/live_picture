defmodule LivePicture.PicturesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LivePicture.Pictures` context.
  """

  @doc """
  Generate a picture.
  """
  def picture_fixture(attrs \\ %{}) do
    {:ok, picture} =
      attrs
      |> Enum.into(%{
        id: "some id",
        path: "some path"
      })
      |> LivePicture.Pictures.create_picture()

    picture
  end
end
