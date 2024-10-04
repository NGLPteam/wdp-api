# frozen_string_literal: true

GeoliteCityPath = Pathname("/usr/share/GeoIP/GeoLite2-City.mmdb")

Geocoder.configure(
  ip_lookup: :geoip2,
  geoip2: {
    file: GeoliteCityPath,
  },
)
