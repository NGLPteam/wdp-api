# frozen_string_literal: true

module Local
  class UpdateWebMaxmind
    include Dry::Monads[:result]

    GEOIPUPDATE_PATH = "/usr/local/bin/geoipupdate"

    def call
      env = GeocoderConfig.to_env

      output, pid = Open3.capture2e(env, GEOIPUPDATE_PATH)

      Rails.logger.tagged("geoipupdate").debug(output)

      # :nocov:
      return Failure[:update_failed, output] unless pid.success?
      # :nocov:

      Success()
    end
  end
end
