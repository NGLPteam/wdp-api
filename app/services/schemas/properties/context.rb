# frozen_string_literal: true

module Schemas
  module Properties
    # A context used for reading values and also produced by {Schemas::Properties::WriteContext}
    # to persist the values with {Schemas::Instances::ApplyValueContext}
    class Context
      extend Dry::Initializer

      EMPTY_HASH = proc { {} }

      option :values, AppTypes::ValueHash, default: EMPTY_HASH
      option :collected_references, AppTypes::CollectedReferenceMap, default: EMPTY_HASH
      option :scalar_references, AppTypes::ScalarReferenceMap, default: EMPTY_HASH

      # @param [String] path
      # @return [<ApplicationRecord>]
      def collected_reference(path)
        collected_references.fetch path, []
      end

      # @param [String] path
      # @return [ApplicationRecord, nil]
      def scalar_reference(path)
        scalar_references[path]
      end

      # @param [String] path
      # @return [Object, nil]
      def value_at(path)
        parts = path.split(?.)

        values.dig(*parts)
      end
    end
  end
end
