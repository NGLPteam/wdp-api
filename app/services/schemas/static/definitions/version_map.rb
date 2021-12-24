# frozen_string_literal: true

module Schemas
  module Static
    module Definitions
      class VersionMap < Schemas::Static::VersionMap
        version_klass Schemas::Static::Definitions::Version

        validate :must_be_same_kind!

        delegate :kind, to: :latest, prefix: true

        delegate :to_definition_attributes, :to_definition_tuple, to: :latest

        def has_same_kind?
          all? do |version|
            version.kind == latest_kind
          end
        end

        private

        # @return [void]
        def must_be_same_kind!
          errors.add :base, "must all be for the same kind" unless has_same_kind?
        end
      end
    end
  end
end
