defmodule JirelloWeb.TasksLive do
  use JirelloWeb, :live_view
  alias Jirello.Tasks

  def mount(_params, _session, socket) do
    Tasks.subscribe()

    {:ok, fetch(socket)}
  end

  def handle_event("add", %{"task" => task}, socket) do
    Tasks.create_task(task)

    {:noreply, socket}
  end

  def handle_event("complete", %{"id" => id}, socket) do
    task = Tasks.get_task!(id)
    Tasks.update_task(task, %{done: !task.done})

    {:noreply, socket}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    task = Tasks.get_task!(id)
    Tasks.delete_task(task)

    {:noreply, socket}
  end

  def handle_info({Tasks, [:task | _], _}, socket) do
    {:noreply, fetch(socket)}
  end

  defp fetch(socket) do
    assign(socket, tasks: Tasks.list_tasks())
  end
end
