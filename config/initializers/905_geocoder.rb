# frozen_string_literal: true

GeoliteCityPath =
  if ENV["GEOIP_GEOLITE2_PATH"] && ENV["GEOIP_GEOLITE2_CITY_FILENAME"]
    Pathname(File.join(ENV["GEOIP_GEOLITE2_PATH"], ENV["GEOIP_GEOLITE2_CITY_FILENAME"]))
  else
    Rails.root.join("vendor", "GeoLite2-City.mmdb")
  end

Geocoder.configure(
  ip_lookup: :geoip2,
  geoip2: {
    file: GeoliteCityPath,
  },
)
