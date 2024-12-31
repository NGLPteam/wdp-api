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

      # @param [Gem::Version, String, Integer] version
      def satisfied_by?(other)
        case other
        when Gem::Version
          version.satisfied_by?(other)
        else
          satisfied_by?(Gem::Version.new(other))
        end
      end

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
        map_content to: :version, using: { from: :xml_to_version, to: :version_to_xml }
      end

      def xml_to_version(model, node)
        model.version = Schemas::Mappers::VersionRequirement.of_xml(node)
      end

      # @param [Schemas::Mappers::SchemaDeclaration] model
      # @param [Ox::Element] parent
      # @param [Shale::Adapter::Ox::Document] doc
      # @return [void]
      def version_to_xml(model, parent, doc)
        Schemas::Mappers::VersionRequirement.to_xml(model.version, parent, doc)
      end
    end
  end
end
