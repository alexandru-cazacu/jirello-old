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

  def handle_event("select-per-page", %{"per_page" => per_page}, socket) do
    per_page = String.to_integer(per_page)

    socket =
      push_patch(socket,
        to:
          Routes.live_path(
            socket,
            __MODULE__,
            page: socket.assigns.options.page,
            per_page: per_page,
            sort_by: socket.assigns.options.sort_by,
            sort_order: socket.assigns.options.sort_order
          )
      )

    {:noreply, socket}
  end

  def handle_info({Tasks, [:task | _], _}, socket) do
    {:noreply, fetch(socket)}
  end

  # TODO(alex): Mismatch between fetch and handle params. When completing a task sorting by title the page refresh in a weird way.

  def handle_params(params, _url, socket) do
    page = String.to_integer(params["page"] || "1")
    per_page = String.to_integer(params["per_page"] || "5")

    sort_by = (params["sort_by"] || "id") |> String.to_atom()
    sort_order = (params["sort_order"] || "asc") |> String.to_atom()

    paginate_options = %{page: page, per_page: per_page}
    sort_options = %{sort_by: sort_by, sort_order: sort_order}

    tasks =
      Tasks.list_tasks(
        paginate: paginate_options,
        sort: sort_options
      )

    socket =
      assign(socket,
        options: Map.merge(paginate_options, sort_options),
        tasks: tasks
      )

    {:noreply, socket}
  end

  defp fetch(socket) do
    paginate_options = %{page: 1, per_page: 5}
    tasks = Tasks.list_tasks(paginate: paginate_options)

    assign(socket,
      options: paginate_options,
      tasks: tasks
    )
  end

  defp sort_link(socket, sort_by, options, class, do: block) do
    live_patch(
      to:
        Routes.live_path(
          socket,
          __MODULE__,
          sort_order: toggle_sort_order(options.sort_order),
          sort_by: sort_by,
          page: options.page,
          per_page: options.per_page
        ),
      class: class,
      do: block
    )
  end

  defp toggle_sort_order(:asc), do: :desc
  defp toggle_sort_order(:desc), do: :asc
end
