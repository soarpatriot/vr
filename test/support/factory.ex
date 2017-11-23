defmodule Vr.Factory do 
  use ExMachina.Ecto, repo: Vr.Repo
   
  def user_factory do 
    %Vr.User {
      name: "aa",
      email: sequence(:email, &"eamil-#{&1}@example.com"),
      password: "22222222",
      status: :registered
    }

  end
  def asset_factory do 
    %Vr.Asset {
      filename: "aa",
      full: "cc"
    }

  end
  def cover_factory do 
    %Vr.Cover {
      full: "cc",
      post: build(:post)
    }
  end
   def comment_factory do 
    %Vr.Comment {
      content: "df"
    }

  end
 
  def post_factory do 
    %Vr.Post {
      user_id: 3333,
      title: "df",
      description: "ff",
    }

  end
  def highlight_factory do 
    %Vr.Highlight {
    }

  end


end
