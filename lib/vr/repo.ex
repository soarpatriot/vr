defmodule Vr.Repo do
  use Ecto.Repo, otp_app: :vr
  use Scrivener, page_size: 10
end
