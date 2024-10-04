# frozen_string_literal: true

class GeocoderConfig < ApplicationConfig
  EDITION_IDS = "GeoLite2-ASN GeoLite2-City GeoLite2-Country"

  attr_config :account_id, :license_key, preserve_file_times: true, verbose: true

  coerce_types account_id: :string, license_key: :string, preserve_file_times: :boolean, verbose: :boolean

  def to_env
    {
      "GEOIPUPDATE_ACCOUNT_ID" => account_id,
      "GEOIPUPDATE_LICENSE_KEY" => license_key,
      "GEOIPUPDATE_EDITION_IDS" => EDITION_IDS,
      "GEOIPUPDATE_PRESERVE_FILE_TIMES" => to_env_bool(preserve_file_times),
      "GEOIPUPDATE_VERBOSE" => to_env_bool(verbose),
    }
  end

  private

  def to_env_bool(value)
    value ? ?1 : ?0
  end
end
