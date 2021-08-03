# frozen_string_literal: true

module Mutations
  module Operations
    module AssignsSchemaVersion
      extend ActiveSupport::Concern

      included do
        before_validation :maybe_load_schema_version_slug!
      end

      SCHEMA_VERSION_ERROR_PATH = %w[schemaVersionSlug].freeze

      # @return [void]
      def maybe_load_schema_version_slug!
        slug = local_context[:args][:schema_version_slug]

        if slug.blank?
          add_error! "must be provided", code: "NO_VERSION_SLUG", path: SCHEMA_VERSION_ERROR_PATH

          return
        end

        found = WDPAPI::Container["schemas.versions.find"].call(slug)

        with_result! found do |m|
          m.success do |version|
            local_context[:schema_version] = version
          end

          m.failure do |(code, message)|
            add_error! message, code: code, path: SCHEMA_VERSION_ERROR_PATH
          end
        end
      end

      # @return [SchemaVersion]
      def fetch_found_schema_version!
        local_context.fetch(:schema_version)
      end
    end
  end
end
