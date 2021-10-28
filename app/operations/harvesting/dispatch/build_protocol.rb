# frozen_string_literal: true

module Harvesting
  module Dispatch
    class BuildProtocol
      include WDPAPI::Deps[
        oai: "harvesting.protocols.oai",
      ]

      HAS_HARVEST_SOURCE = AppTypes.Interface(:harvest_source)

      # @param [HarvestSource, #harvest_source] origin
      # @return [Dry::Monads::Success(Harvesting::Protocols::BaseProtocol)]
      # @return [Dry::Monads::Failure(Symbol, String)]
      def call(origin)
        case origin
        when HarvestSource
          case origin.protocol
          when "oai"
            oai
          else
            # :nocov:
            Failure[:unknown_protocol, "Cannot build protocol class from #{origin.protocol}"]
            # :nocov:
          end
        when HAS_HARVEST_SOURCE
          call origin.harvest_source
        else
          Failure[:unknown_origin, "Cannot derive harvesting protocol from origin: #{origin.inspect}"]
        end
      end
    end
  end
end
