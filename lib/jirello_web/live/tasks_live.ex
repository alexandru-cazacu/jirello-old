defmodule JirelloWeb.TasksLive do
  use JirelloWeb, :live_view
  alias Jirello.Tasks

  def mount(_params, _session, socket) do
    {:ok, fetch(socket)}
  end

  defp fetch(socket) do
    assign(socket, tasks: Tasks.list_tasks())
  end

  def handle_event("add", %{"task" => task}, socket) do
    Tasks.create_task(task)

    {:noreply, fetch(socket)}
  end
end
