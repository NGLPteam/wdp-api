# frozen_string_literal: true

module Schemas
  # Types that are shared across the entire schema ecosystem.
  module Types
    include Dry.Types

    extend Shared::EnhancedTypes

    # A pattern to match a semantic version.
    #
    # @api private
    SEMVER_PATTERN = Regexp.new("(?<semver>#{Semantic::Version::SemVerRegexp.source[2...-2]})").freeze

    # A pattern to represent a signifier for a version. It can either by a semantic version or the literal `latest`,
    # which has a special meaning in certain services.
    SIGNIFIER_PATTERN = Regexp.new("(?:#{SEMVER_PATTERN}|latest)").freeze

    # A pattern for matching a fully-qualified schema declaration with an optional version signifier.
    #
    # @note This pattern also supports both `namespace.identifier` and `namespace:identifier` usages.
    FLEXIBLE_DECLARATION_PATTERN = /\A(?<namespace>[a-z_]+)[.:](?<identifier>[a-z_0-9]+)(?::(?<version>#{SIGNIFIER_PATTERN}))?\z/.freeze

    # A pattern for matching a fully-qualified schema definition.
    #
    # @note This pattern supports only `namespace:identifier` usage.
    DECLARATION_PATTERN = /\A(?<namespace>[a-z_]+):(?<identifier>[a-z_0-9]+)\z/.freeze

    # A pattern for matching a fully-qualified schema declaration with a required version string
    #
    # @note This pattern supports only `namespace:identifier` usage.
    VERSION_DECLARATION_PATTERN = /\A(?<namespace>[a-z_]+):(?<identifier>[a-z_0-9]+):(?<version>[^:\s]+)\z/.freeze

    # A type for matching a fully-qualified schema declaration.
    #
    # It will use {FLEXIBLE_DECLARATION_PATTERN} to match a more lax approach that includes
    # an optional schema version, and it will finesse it into the proper declaration format.
    #
    # @see DECLARATION_PATTERN
    Declaration = String.constrained(format: DECLARATION_PATTERN).constructor do |value|
      case value
      when FLEXIBLE_DECLARATION_PATTERN
        "#{Regexp.last_match[:namespace]}:#{Regexp.last_match[:identifier]}"
      when SchemaVersion
        value.schema_definition.declaration
      when SchemaDefinition
        value.declaration
      else
        value
      end
    end

    SchemaInstance = Instance(::Community) | Instance(::Collection) | Instance(::Item)

    ChildAssociation = Symbol.enum(:collections, :children, :items)

    NullifiableAssociation = Symbol.enum(:parent)

    ParentAssociation = Symbol.enum(:community, :parent, :collection)

    ParentInheritableAssociation = Symbol.enum(:community, :collection)

    Kind = Coercible::String.enum("community", "collection", "item").constructor do |value|
      case value
      when SchemaDefinition, SchemaVersion, Schemas::Versions::Configuration
        value.kind
      when Community, Collection, Item, Entity
        value.schema_kind
      else
        value
      end
    end

    # A type for matching a fully qualified, versioned schema declaration.
    VersionDeclaration = String.constrained(format: VERSION_DECLARATION_PATTERN).constructor do |value|
      case value
      when SchemaVersion then value.declaration
      else
        value
      end
    end
  end
end
