# frozen_string_literal: true

module Schemas
  module Static
    class LoadDefinition
      include Dry::Monads[:do, :result]
      include MonadicPersistence
      include MeruAPI::Deps[load_version: "schemas.static.load_version", parse: "schemas.parse_full_identifier", reorder_versions: "schemas.versions.reorder"]

      IDENTIFIER = /\A(?<namespace>[^.:]+)[.:](?<identifier>[^.:]+)\z/

      # @param [String] identifier
      # @param [Schemas::Static::Definitions::VersionMap] versions
      # @return [SchemaDefinition]
      def call(identifier, versions)
        yield validate versions

        definition = yield find_or_create_definition identifier, versions

        versions.each do |version|
          yield load_version.call(definition, version)
        end

        yield reorder_versions.call definition

        Success definition
      end

      private

      def find_or_create_definition(full_identifier, versions)
        namespace, id = yield parse.call(full_identifier)

        definition = SchemaDefinition.lookup_or_initialize namespace, id

        definition.assign_attributes versions.to_definition_attributes

        monadic_save definition
      end

      def validate(versions)
        if versions.valid?
          Success nil
        else
          Failure[:invalid_version_map, versions.errors.full_messages.to_sentence]
        end
      end
    end
  end
end
