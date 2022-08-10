defmodule JirelloWeb.RemoteIp do
  def get(conn) do
    forwarded_for = List.first(Plug.Conn.get_req_header(conn, "x-forwarded-for"))

    if forwarded_for do
      forwarded_for
      |> String.split(",")
      |> Enum.map(&String.trim/1)
      |> List.first()
    else
      to_string(:inet_parse.ntoa(conn.remote_ip))
    end
  end
end
