# frozen_string_literal: true

module Schemas
  module Static
    TypeRegistry = Support::Schemas::TypeContainer.new.configure do |tc|
      tc.add! :component, ::Schemas::Static::Types::Component

      tc.add! :definition_declaration, ::Schemas::Static::Types::DefinitionDeclaration

      tc.add! :namespace, ::Schemas::Static::Types::Namespace

      tc.add! :identifier, ::Schemas::Static::Types::Component

      tc.add! :pathname, ::Schemas::Static::Types::Pathname

      tc.add! :schema_kind, ::Schemas::Static::Types::SchemaKind

      tc.add! :semantic_version, ::Schemas::Static::Types::SemanticVersion

      tc.add! :version_declaration, ::Schemas::Static::Types::VersionDeclaration

      tc.add! :version_number, ::Schemas::Static::Types::VersionNumber
    end
  end
end
