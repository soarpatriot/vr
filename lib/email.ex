defmodule Vr.Email do 
  use Bamboo.Phoenix, view: Vr.EmailView
  # import Bamboo.Email
  # import Bamboo.Phoenix
  def welcome_text_email(email_address) do
    new_email()
    |> to(email_address)
    |> from("soarpatriot@126.com")
    |> subject("Welcome!")
    # |> text_body("Welcome to MyApp!")
  end
  def validate_html_email(email_address, url, name) do
    new_email()
    |> to(email_address)
    |> from(from_email())
    |> subject("三维云账号激活")
 
    # |> html_body("<strong>Welcome<strong> to MyApp new ....!")
    # |> put_html_layout({Vr.LayoutView, "email.html"})
    |> render("confirmation.html", %{url: url, name: name}) # <= Assignments
  end
  def forgot_html_email(email_address, url, name) do
    new_email()
    |> to(email_address)
    |> from(from_email())
    |> subject("三维云重制密码")
 
    # |> html_body("<strong>Welcome<strong> to MyApp new ....!")
    # |> put_html_layout({Vr.LayoutView, "email.html"})
    |> render("reset.html", %{url: url, name: name}) # <= Assignments
  end


  defp from_email() do 
    Application.get_env(:vr, Vr.Mailer)[:account_name]
  end
end
