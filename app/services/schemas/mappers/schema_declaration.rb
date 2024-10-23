# frozen_string_literal: true

module Schemas
  module Mappers
    # A mapper that corresponds to a schema version,
    # with optional version specifiers using rubygems semantic versioning.
    #
    # @see Schemas::Mappers::VersionRequirement
    class SchemaDeclaration < Shale::Mapper
      attribute :namespace, Shale::Type::String
      attribute :identifier, Shale::Type::String
      attribute :version, Schemas::Mappers::VersionRequirement

      # @return [::Schemas::Associations::OrderingFilter]
      def to_ordering_filter
        ::Schemas::Associations::OrderingFilter.new(as_json)
      end

      json do
        map "namespace", to: :namespace
        map "identifier", to: :identifier
        map "version", to: :version
      end

      xml do
        root "schema"

        map_attribute "namespace", to: :namespace
        map_attribute "identifier", to: :identifier
        map_content to: :version, cdata: true
      end
    end
  end
end
