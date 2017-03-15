defmodule Vr.Email do 
  use Bamboo.Phoenix, view: Vr.EmailView
  # import Bamboo.Email
  # import Bamboo.Phoenix
  def welcome_text_email(email_address) do
    new_email
    |> to(email_address)
    |> from("soarpatriot@126.com")
    |> subject("Welcome!")
    # |> text_body("Welcome to MyApp!")
  end
  def welcome_html_email(email_address, url) do
    email_address
    |> welcome_text_email()
    # |> html_body("<strong>Welcome<strong> to MyApp new ....!")
    # |> put_html_layout({Vr.LayoutView, "email.html"})
    |> render("confirmation.html", %{url: "http://aa", name: "ccc"}) # <= Assignments
  end

end
