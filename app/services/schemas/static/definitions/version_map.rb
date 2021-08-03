# frozen_string_literal: true

module Schemas
  module Static
    module Definitions
      class VersionMap < Schemas::Static::VersionMap
        version_klass Schemas::Static::Definitions::Version

        validate :must_be_same_consumer!

        delegate :consumer, to: :latest, prefix: true

        delegate :to_definition_attributes, :to_definition_tuple, to: :latest

        def has_same_consumer?
          all? do |version|
            version.consumer == latest_consumer
          end
        end

        private

        # @return [void]
        def must_be_same_consumer!
          errors.add :base, "must all be for the same consumer" unless has_same_consumer?
        end
      end
    end
  end
end
