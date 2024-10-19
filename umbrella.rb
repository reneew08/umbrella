require "dotenv/load"
require "http"
require "json"

puts "========================================"
puts "   Will you need an umbrella today?     "
puts "========================================\n"

puts "Where are you?"
user_location=gets.chomp()

gmaps_key=ENV.fetch("GMAPS_KEY")
pirate_key=ENV.fetch("PIRATE_WEATHER_KEY")

gmaps_url="https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{gmaps_key}"

raw_gmaps=HTTP.get(gmaps_url)
parsed_gmaps=JSON.parse(raw_gmaps)
results_array=parsed_gmaps.fetch("results")
address_hash=results_array.at(0)
geom_hash=address_hash.fetch("geometry")
location_hash=geom_hash.fetch("location")
lat=location_hash.fetch("lat")
lng=location_hash.fetch("lng")


pirate_url="https://api.pirateweather.net/forecast/" + pirate_key + "/#{lat},#{lng}"

raw_pirate=HTTP.get(pirate_url)
parsed_pirate=JSON.parse(raw_pirate)
currently_hash=parsed_pirate.fetch('currently')
current_temp=currently_hash.fetch('temperature')
current_precip=currently_hash.fetch('precipProbability')
minutely_hash = parsed_pirate.fetch("minutely")
hourly_hash = parsed_pirate.fetch("hourly")

puts "Checking the weather at #{user_location}...."
puts "Your coordinates are #{lat}, #{lng}."
puts "It is currently #{current_temp}°F."
if minutely_hash
  next_hour_summary = minutely_hash.fetch("summary")
  puts "Next hour: #{next_hour_summary}"
end
hourly_data_array=hourly_hash.fetch("data")
hourly_data_array[1..12].each do |hour|
  precip=hour.fetch("precipProbability")
  puts "In test hours, there is a #{(precip*100).round(0)}% chance of precipitation."
end
#pp parsed_gmaps
