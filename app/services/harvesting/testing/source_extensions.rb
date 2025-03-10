# frozen_string_literal: true

module Harvesting
  module Testing
    # Extensions for assisting with testing {HarvestSource}
    # using the {Harvesting::Testing} namespace.
    module SourceExtensions
      extend ActiveSupport::Concern

      # @return [HarvestTarget, nil]
      attr_accessor :default_target_entity

      # @return [Harvesting::Testing::ProviderDefinition, nil]
      attr_accessor :testing_provider

      # @return [Harvesting::Testing::OAI::SampleRecord, nil]
      def available_sample_record
        find_testing_provider!.try(:record_klass).try(:available_sample_for, self)
      end

      # @return [Harvesting::Testing::ProviderDefinition, nil]
      def find_testing_provider!
        @testing_provider ||= try_to_find_testing_provider
      end

      private

      # @return [Harvesting::Testing::ProviderDefinition, nil]
      def try_to_find_testing_provider
        Harvesting::Testing::ProviderDefinition.by_protocol(protocol).by_metadata_format(metadata_format).first ||
          Harvesting::Testing::ProviderDefinition.oai.first
      end
    end
  end
end
