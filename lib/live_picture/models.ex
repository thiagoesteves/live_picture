defmodule LivePicture.Models do
  @moduledoc """
  The Models context.
  """

  alias LivePicture.Models.Supervisor, as: ModelSup

  @doc """
  Create Models
  """
  @spec create_model(String.t()) :: {:ok, pid} | {:error, pid(), :already_started}
  def create_model(name), do: ModelSup.start_child(name)

  @doc """
  List Models
  """
  @spec list() :: list()
  def list do
    ModelSup
    |> Supervisor.which_children()
    |> Enum.reduce([], fn {_index, pid, :worker, _name}, acc ->
      acc ++ get_model_name(pid)
    end)
  end

  defp get_model_name(pid) do
    %{name: name} = :sys.get_state(pid, 100)
    [name]
  catch
    _, _ ->
      []
  end
end
