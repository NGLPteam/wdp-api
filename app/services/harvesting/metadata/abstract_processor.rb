# frozen_string_literal: true

module Harvesting
  module Metadata
    # @abstract
    class AbstractProcessor
      extend Dry::Initializer

      param :harvest_source, AppTypes.Instance(HarvestSource)

      # @abstract
      # @return [String]
      def format
        raise NotImplementedMethod, "Must implement #{self.class}##{__method__}"
      end

      # @abstract
      # @return [String]
      def oai_metadata_prefix
        raise NotImplementedMethod, "Must implement #{self.class}##{__method__}"
      end
    end
  end
end
