# frozen_string_literal: true

module Harvesting
  module Testing
    # Extensions for assisting with testing {HarvestRecord}
    # using the {Harvesting::Testing} namespace.
    module RecordExtensions
      extend ActiveSupport::Concern

      # @return [Harvesting::Testing::OAI::SampleRecord, nil]
      attr_accessor :sample_record

      # @return [Harvesting::Testing::OAI::SampleRecord, nil]
      def find_sample_record!
        @sample_record ||= try_to_find_sample_record
      end

      private

      # @return [Harvesting::Testing::OAI::SampleRecord, nil]
      def try_to_find_sample_record
        harvest_source.try(:available_sample_record)
      end
    end
  end
end
