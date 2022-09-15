# frozen_string_literal: true

module Analytics
  # Use an `UPDATE` statement. Better performing.
  class UpdateGeocoding
    include Dry::Monads[:do, :result]
    include WDPAPI::Deps[
      lookup: "geocoding.lookup",
    ]

    # @param [String] visit_token
    # @param [String] ip
    def call(visit_token, ip)
      data = yield lookup.(ip)

      attributes = data.to_h

      attributes[:geocoded_at] = Time.current

      Ahoy::Visit.where(visit_token: visit_token).update_all(attributes)

      Success()
    end
  end
end
