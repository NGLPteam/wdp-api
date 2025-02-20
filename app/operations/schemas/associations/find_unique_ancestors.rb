# frozen_string_literal: true

module Schemas
  module Associations
    class FindUniqueAncestors
      include Dry::Monads[:result, :do]

      # @param [<SchemaVersion>] versions
      def call(*versions)
        versions.flatten!

        ancestors = versions.flat_map do |version|
          version.schema_version_ancestors.to_a
        end.uniq { [_1.name, _1.target_version_id] }

        Success ancestors
      end
    end
  end
end
