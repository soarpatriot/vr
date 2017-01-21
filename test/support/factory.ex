defmodule Vr.Factory do 
  use ExMachina.Ecto, repo: Vr.Repo
   
  def user_factory do 
    %Vr.User {
      name: "aa",
      email: sequence(:email, &"eamil-#{&1}@example.com"),
      password: "22222222"
    }
  end
end
