# frozen_string_literal: true

module Testing
  module Merced
    # Iterate over the parsed units and process the campuses.
    #
    # @api private
    # @operation
    class ProcessUnits
      include Dry::Monads[:do, :result]
      include Dry::Effects.Resolve(:units)
      include Dry::Effects.State(:unit_ids)
      include WDPAPI::Deps[
        process_unit: "testing.merced.process_unit",
      ]
      prepend HushActiveRecord

      # @return [Dry::Monads::Result]
      def call
        units.each do |unit|
          next unless unit[:type] == "campus"
          next if unit[:id].in?(unit_ids)

          yield process_unit.call unit
        end

        Success nil
      end
    end
  end
end
