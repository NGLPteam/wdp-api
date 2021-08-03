# frozen_string_literal: true

module Schemas
  module Versions
    # Look up a {SchemaVersion} with a certain type of needle
    class Find
      include Dry::Monads[:do, :result]

      PATTERN = /\A(?<namespace>[a-z_]+)[.:](?<identifier>[a-z_0-9]+)(?::(?<version>[^:]+))?\z/.freeze

      def call(needle)
        case needle
        when PATTERN
          parsed = Regexp.last_match.named_captures.symbolize_keys

          look_up_by_slug needle, **parsed
        when AppTypes::UUID
          find_by id: needle
        when ::SchemaVersion
          Success needle
        when ::SchemaDefinition
          Success needle.schema_versions.latest!
        else
          Failure[:invalid_needle, "Unable to find version with #{needle.inspect}"]
        end
      end

      private

      def look_up_by_slug(needle, namespace:, identifier:, version: nil)
        scope = SchemaVersion.by_tuple namespace, identifier

        case version
        when Semantic::Version::SemVerRegexp
          Success scope.lookup version
        when nil, /\Alatest\z/i
          Success scope.latest!
        else
          Failure[:unknown_version_specifier, "Unknown version: #{version.inspect} for #{needle.inspect}"]
        end
      rescue LimitToOne::TooManyMatches
        # :nocov:
        Failure[:too_many_matches, "Too many matches for #{needle.inspect}"]
        # :nocov:
      rescue ActiveRecord::RecordNotFound
        Failure[:unknown_version, "No version found for #{needle.inspect}"]
      end

      def look_up_by_id(id)
        try_schema_version_find(id).or do |_|
          try_schema_definition_find id
        end
      end

      def try_schema_definition_find(id)
        definition = yield try_model SchemaDefinition, id

        Success definition.schema_versions.latest!
      end

      def try_schema_version_find(id)
        try_model SchemaVersion, id
      end

      def try_model(klass, id)
        Success klass.find id
      rescue ActiveRecord::RecordNotFound
        Failure[:unknown_id, "#{id.inspect} not found"]
      end
    end
  end
end
