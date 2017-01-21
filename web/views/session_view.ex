defmodule Vr.SessionView do
  use Vr.Web, :view



  def render("session.json", %{token: token}) do
    %{
      token: token
    }
  end
  def render("error.json", %{msg: msg}) do
    %{
      msg: msg
    }
  end

end
