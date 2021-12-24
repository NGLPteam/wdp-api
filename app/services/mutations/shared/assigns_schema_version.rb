# frozen_string_literal: true

module Mutations
  module Shared
    # @see Mutations::Contracts::AssignsSchemaVersion
    module AssignsSchemaVersion
      extend ActiveSupport::Concern

      included do
        use_contract! :assigns_schema_version

        after_prepare :maybe_load_schema_version_slug!
      end

      # @return [void]
      def maybe_load_schema_version_slug!
        with_called_operation!("schemas.versions.find", local_context[:args][:schema_version_slug]) do |m|
          m.success do |version|
            local_context[:schema_version] = version
          end

          m.failure do
            # intentionally left blank, let the contract handle it
          end
        end
      end

      # @return [SchemaVersion]
      def loaded_schema_version
        local_context.fetch(:schema_version)
      end

      alias fetch_found_schema_version! loaded_schema_version
    end
  end
end
