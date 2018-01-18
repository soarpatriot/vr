defmodule Vr.Part do
  use Vr.Web, :model

  schema "parts" do
    field :name, :string
    field :size, :integer
    belongs_to :asset, Vr.Asset

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :size])
    |> validate_required([:name, :size])
  end

  def list([head | tail]) do 
    [changeset(%Vr.Part{}, head) | list(tail) ]
    #  [Ecto.Changeset.change(%Vr.Part{},name: head, size: ) | list(tail) ] 
  end

  def list([]) do 
    []
  end

  def list(nil) do 
    []
  end
  def part_size([]) do 
    []
  end
  def part_size([part | tail]) do 
    name = part.name
    re = relative_path(part.asset.relative)
    url = "#{Application.get_env(:vr, Vr.Assets)[:asset_url]}/files/info/#{name}?relative=#{re}"
    size = file_size(url) 
    part_update(part, size)
    part_size(tail)
  end
  def part_update(part, size) do 
    part = Ecto.Changeset.change part, size: size
    case Vr.Repo.update part do
			{:ok, part}       -> # Updated with success
        IO.puts "update #{part.id} success"
			{:error, changeset} -> # Something went wrong
        IO.puts "update #{part.id} fail"
		end
   
  end 
  def relative_path(rpath) do 
    String.split(rpath, ".") |> hd
  end
  def file_size(url) do 
		case HTTPoison.get(url) do
			{:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
				IO.puts body
        case JSON.decode(body) do 
          {:ok, data} -> 
            Map.get(data, "size")
          _ ->
            0
        end
         
			{:ok, %HTTPoison.Response{status_code: 404}} ->
				IO.puts "Not found :("
        0
			{:error, %HTTPoison.Error{reason: reason}} ->
				IO.inspect reason
        0
		end
  end
end
