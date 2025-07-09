# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ParkVotingPhoenix.Repo.insert!(%ParkVotingPhoenix.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ParkVotingPhoenix.Repo
alias ParkVotingPhoenix.Parks.Park

# Ensure the HTTP client is started
:inets.start()
:ssl.start()

# Read parks from JSON file
parks_json = File.read!("park-images.json") |> Jason.decode!()

# Manual corrections for parks with 404 errors
parks_json = Map.merge(parks_json, %{
  "Great Sand Dunes National Park" => "https://upload.wikimedia.org/wikipedia/commons/thumb/7/74/Sun_and_Shadow_Patterns_on_Dunes_%2828471118064%29.jpg/330px-Sun_and_Shadow_Patterns_on_Dunes_%2828471118064%29.jpg",
  "Mammoth Cave National Park" => "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f5/Mammoth_Cave_National_Park_007.jpg/330px-Mammoth_Cave_National_Park_007.jpg",
  "White Sands National Park" => "https://upload.wikimedia.org/wikipedia/commons/thumb/1/10/White_Sands_New_Mexico_USA.jpg/330px-White_Sands_New_Mexico_USA.jpg",
  "New River Gorge National Park" => "https://upload.wikimedia.org/wikipedia/commons/thumb/1/11/New_River_Gorge_Bridge.jpg/330px-New_River_Gorge_Bridge.jpg"
})

# Set the directory for storing images
images_dir = Path.join([File.cwd!(), "priv", "static", "images", "parks"])
File.mkdir_p!(images_dir)

# Track download statistics
download_stats = %{
  success: [],
  failure: %{}
}

IO.puts("\n=== Starting image downloads (#{map_size(parks_json)} parks) ===\n")
IO.puts("Images directory: #{images_dir}\n")

# Process each park and track stats
final_stats = Enum.reduce(parks_json, download_stats, fn {name, url}, stats ->
  # Create a URL-friendly slug from the park name
  slug = name
         |> String.downcase()
         |> String.replace(~r/[^\w\s]/, "")
         |> String.replace(~r/\s+/, "-")
  
  local_filename = "#{slug}.jpg"
  local_path = Path.join(images_dir, local_filename)
  
  IO.puts("Processing: #{name} (#{url})")

  # Prepare headers with User-Agent to comply with Wikipedia policy
  # Headers must be charlists for Erlang's httpc
  headers = [
    {~c"User-Agent", ~c"ParkVotingPhoenix/1.0 (https://github.com/yourusername/park_voting_phoenix; your-email@example.com) Elixir/:httpc"}
  ]
  
  # Attempt to download with detailed error tracking
  download_result = case :httpc.request(:get, {String.to_charlist(url), headers}, [timeout: 30000], body_format: :binary) do
    {:ok, {{_, 200, reason}, headers, body}} ->
      File.write!(local_path, body)
      IO.puts("  ✓ Downloaded successfully (#{byte_size(body)} bytes)")
      {:success, name}
      
    {:ok, {{_, status_code, reason}, headers, _}} ->
      IO.puts("  ✗ Failed with status #{status_code}: #{reason}")
      {:error, name, "HTTP #{status_code}: #{reason}"}
      
    {:error, reason} ->
      error_msg = "#{inspect(reason)}"
      IO.puts("  ✗ Request error: #{error_msg}")
      {:error, name, error_msg}
  end
  
  # Update stats based on download result
  updated_stats = case download_result do
    {:success, park_name} ->
      %{stats | success: [park_name | stats.success]}
      
    {:error, park_name, reason} ->
      failures = Map.update(stats.failure, reason, [park_name], fn parks -> [park_name | parks] end)
      %{stats | failure: failures}
  end
  
  # Set image URL based on download success
  download_successful = match?({:success, _}, download_result)
  image_url = if download_successful, do: "/images/parks/#{local_filename}", else: url
  
  # Add delay to avoid rate limiting
  :timer.sleep(100)
  
  # Update or create park record
  case Repo.get_by(Park, name: name) do
    nil ->
      %Park{}
      |> Park.changeset(%{name: name, image_url: image_url})
      |> Repo.insert!()

    park ->
      if park.image_url != image_url do
        park
        |> Park.changeset(%{image_url: image_url})
        |> Repo.update!()
      end
  end
  
  updated_stats
end)

# Print summary statistics
IO.puts("\n=== Download Summary ===\n")
IO.puts("Total parks: #{map_size(parks_json)}")
IO.puts("Successfully downloaded: #{length(final_stats.success)} parks")

failure_count = Enum.sum(Enum.map(final_stats.failure, fn {_, parks} -> length(parks) end))
IO.puts("Failed downloads: #{failure_count} parks\n")

IO.puts("=== Failure Reasons ===\n")
if map_size(final_stats.failure) == 0 do
  IO.puts("No failures!")
else
  Enum.each(final_stats.failure, fn {reason, parks} ->
    IO.puts("#{reason}:")
    Enum.each(parks, fn park -> IO.puts("  - #{park}") end)
    IO.puts("")
  end)
end
