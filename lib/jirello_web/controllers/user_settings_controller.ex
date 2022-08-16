defmodule JirelloWeb.UserSettingsController do
  use JirelloWeb, :controller

  alias Jirello.Accounts
  alias JirelloWeb.UserAuth

  plug :assign_changesets

  def edit(conn, _params) do
    conn
    |> assign(:page_title, "Settings")
    |> add_sessions()
    |> render("edit.html")
  end

  def update(conn, %{"action" => "update_profile"} = params) do
    %{"user" => user_params} = params
    user = conn.assigns.current_user

    case Accounts.update_user_profile(user, user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Profile updated successfully.")
        |> redirect(to: Routes.user_settings_path(conn, :edit))

      {:error, changeset} ->
        conn
        |> add_sessions()
        |> render("edit.html", profile_changeset: changeset)
    end
  end

  def update(conn, %{"action" => "update_email"} = params) do
    %{"current_password" => password, "user" => user_params} = params
    user = conn.assigns.current_user

    case Accounts.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_update_email_instructions(
          applied_user,
          user.email,
          &Routes.user_settings_url(conn, :confirm_email, &1)
        )

        conn
        |> put_flash(
          :info,
          "A link to confirm your email change has been sent to the new address."
        )
        |> redirect(to: Routes.user_settings_path(conn, :edit))

      {:error, changeset} ->
        conn
        |> add_sessions()
        |> render("edit.html", email_changeset: changeset)
    end
  end

  def update(conn, %{"action" => "update_password"} = params) do
    %{"current_password" => password, "user" => user_params} = params
    user = conn.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Password updated successfully.")
        |> put_session(:user_return_to, Routes.user_settings_path(conn, :edit))
        |> UserAuth.log_in_user(user)

      {:error, changeset} ->
        conn
        |> add_sessions()
        |> render("edit.html", password_changeset: changeset)
    end
  end

  def confirm_email(conn, %{"token" => token}) do
    case Accounts.update_user_email(conn.assigns.current_user, token) do
      :ok ->
        conn
        |> put_flash(:info, "Email changed successfully.")
        |> redirect(to: Routes.user_settings_path(conn, :edit))

      :error ->
        conn
        |> put_flash(:error, "Email change link is invalid or it has expired.")
        |> redirect(to: Routes.user_settings_path(conn, :edit))
    end
  end

  defp assign_changesets(conn, _opts) do
    user = conn.assigns.current_user

    conn
    |> assign(:email_changeset, Accounts.change_user_email(user))
    |> assign(:password_changeset, Accounts.change_user_password(user))
    |> assign(:profile_changeset, Accounts.change_user_profile(user))
  end

  defp add_sessions(conn) do
    sessions = Accounts.list_sessions(conn.assigns.current_user, ["session"])
    user_token = get_session(conn, :user_token)

    sessions =
      Enum.map(sessions, fn session ->
        %{session | is_current: session.token == user_token}
      end)

    assign(conn, :sessions, sessions)
  end

  def delete(conn, %{"session_id" => session_id}) do
    user_token = Accounts.get_session!(session_id)
    {:ok, _user_token} = Accounts.revoke_session(user_token)

    conn
    |> put_flash(:info, "Session revoked successfully.")
    |> redirect(to: Routes.user_settings_path(conn, :edit))

    conn
  end
end
