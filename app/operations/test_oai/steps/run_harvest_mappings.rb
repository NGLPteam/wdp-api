# frozen_string_literal: true

module TestOAI
  module Steps
    class RunHarvestMappings
      include Dry::Monads[:do, :result]
      include MonadicPersistence
      include WDPAPI::Deps[
        manually_run_mapping: "harvesting.actions.manually_run_mapping",
      ]

      # @param [HarvestSource] source
      def call(source)
        source.harvest_mappings.find_each do |mapping|
          yield manually_run_mapping.call mapping
        end

        Success nil
      end
    end
  end
end
