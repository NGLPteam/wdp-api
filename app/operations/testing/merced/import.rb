# frozen_string_literal: true

module Testing
  module Merced
    # Import merced units into a standardized community.
    #
    # @api private
    # @operation
    class Import
      include Dry::Monads[:result, :do]
      include Dry::Effects::Handler.Resolve
      include Dry::Effects::Handler.State(:unit_ids)

      include WDPAPI::Deps[
        parse_units: "testing.merced.parse_units",
        process_units: "testing.merced.process_units",
        scaffold_community: "testing.merced.scaffold_community"
      ]

      prepend HushActiveRecord

      def call
        base_state = {}

        base_state[:community] = yield scaffold_community.call

        base_state[:units] = yield parse_units.call

        ids = Set.new

        unit_ids, _ = with_unit_ids(ids) do
          provide base_state do
            yield process_units.call
          end
        end

        Success unit_ids
      end
    end
  end
end