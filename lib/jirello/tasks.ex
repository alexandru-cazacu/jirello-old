defmodule Jirello.Tasks do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false
  alias Jirello.Repo

  alias Jirello.Tasks.Task

  @topic inspect(__MODULE__)

  def subscribe do
    Phoenix.PubSub.subscribe(Jirello.PubSub, @topic)
  end

  defp broadcast_change({:error, changeset}, _event) do
    {:error, changeset}
  end

  defp broadcast_change({:ok, result}, event) do
    Phoenix.PubSub.broadcast(Jirello.PubSub, @topic, {__MODULE__, event, result})

    {:ok, result}
  end

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks do
    Repo.all(Task)
  end

  @doc """
  Returns the list of tasks matching the given `criteria`.

  ## Example

    [
      paginate: %{page: 2, per_page: 5},
      sort: %{sort_by: :item, sort_order: :asc}
    ]
  """
  def list_tasks(criteria) when is_list(criteria) do
    query = from(t in Task)

    query =
      Enum.reduce(criteria, query, fn
        {:paginate, %{page: page, per_page: per_page}}, query ->
          from q in query,
            offset: ^((page - 1) * per_page),
            limit: ^per_page

        {:sort, %{sort_by: sort_by, sort_order: sort_order}}, query ->
          from q in query, order_by: [{^sort_order, ^sort_by}]
      end)

    Repo.all(query)
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id), do: Repo.get!(Task, id)

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
    |> broadcast_change([:task, :created])
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
    |> broadcast_change([:task, :updated])
  end

  @doc """
  Deletes a task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    task
    |> Repo.delete()
    |> broadcast_change([:task, :deleted])
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{data: %Task{}}

  """
  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end
end
