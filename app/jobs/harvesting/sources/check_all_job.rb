# frozen_string_literal: true

module Harvesting
  module Sources
    # @see HarvestSource#check
    # @see Harvesting::Sources::Check
    # @see Harvesting::Sources::Checker
    class CheckAllJob < ApplicationJob
      include JobIteration::Iteration

      queue_as :maintenance

      # @return [void]
      def build_enumerator(cursor:)
        enumerator_builder.active_record_on_records(HarvestSource.all, cursor:)
      end

      # @see HarvestSource#check
      # @param [HarvestSource] harvest_source
      # @return [void]
      def each_iteration(harvest_source)
        harvest_source.check
      end
    end
  end
end
