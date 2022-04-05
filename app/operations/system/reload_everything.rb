# frozen_string_literal: true

module System
  # @api private
  class ReloadEverything
    include Dry::Monads[:result, :do]
    include WDPAPI::Deps[
      reload_roles: "roles.sync",
      reload_schemas: "schemas.static.load_definitions",
    ]

    def call
      now = Time.current

      yield reload_roles.call

      yield reload_schemas.call

      SchemaVersion.where(%[updated_at >= ?], now).find_each do |sv|
        warn "Refreshing #{sv.declaration} instances"

        Schemas::Versions::ResetAllOrderingsJob.perform_later sv
      end

      Success()
    end
  end
end
