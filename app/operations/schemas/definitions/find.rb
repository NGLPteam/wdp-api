# frozen_string_literal: true

module Schemas
  module Definitions
    # Look up a {SchemaDefinition} with a certain type of needle
    class Find
      include Dry::Monads[:do, :result]

      PATTERN = /\A(?<namespace>[a-z_]+)[.:](?<identifier>[a-z_0-9]+)(?::[^:]+)?\z/

      def call(needle)
        case needle
        when PATTERN
          parsed = Regexp.last_match.named_captures.symbolize_keys

          look_up_by_slug needle, **parsed
        when ::Support::GlobalTypes::UUID
          find_by id: needle
        when ::SchemaVersion
          Success needle.schema_definition
        when ::SchemaDefinition
          Success needle
        else
          Failure[:invalid_needle, "Unable to find version with #{needle.inspect}"]
        end
      end

      private

      def look_up_by_slug(needle, namespace:, identifier:)
        scope = SchemaDefinition.by_tuple namespace, identifier

        Success scope.first!
      rescue ActiveRecord::RecordNotFound
        Failure[:unknown_version, "No version found for #{needle.inspect}"]
      end

      def look_up_by_id(id)
        try_schema_definition_find(id).or do |_|
          try_schema_version_find id
        end
      end

      def try_schema_definition_find(id)
        definition = yield try_model SchemaDefinition, id

        Success definition
      end

      def try_schema_version_find(id)
        version = yield try_model SchemaVersion, id

        Success version.definition
      end

      def try_model(klass, id)
        Success klass.find id
      rescue ActiveRecord::RecordNotFound
        Failure[:unknown_id, "#{id.inspect} not found"]
      end
    end
  end
end
