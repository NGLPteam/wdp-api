# frozen_string_literal: true

module Templates
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    Assigns = Hash.map(Coercible::String, Any)

    EnumPropertyCategory = Coercible::String.default("none").enum(
      "background",
      "none",
      "selection_mode",
      "variant",
    ).fallback("none")

    EnumPropertyName = Coercible::String.enum(
      "contributor_list_background",
      "descendant_list_background",
      "descendant_list_selection_mode",
      "descendant_list_variant",
      "detail_background",
      "detail_variant",
      "hero_background",
      "link_list_background",
      "link_list_selection_mode",
      "link_list_variant",
      "metadata_background",
      "navigation_background",
      "ordering_background",
      "page_list_background",
      "selection_source_mode",
      "supplementary_background"
    )

    DescendantListSelectionMode = ApplicationRecord.dry_pg_enum(:descendant_list_ordering_mode)

    Entity = Instance(::HierarchicalEntity)

    ErrorMode = Coercible::Symbol.default(:strict).enum(:strict, :warn, :lax).fallback(:strict)

    Generation = String.constrained(uuid_v4: true)

    Kind = TemplateKind = ApplicationRecord.dry_pg_enum(:template_kind)

    Kinds = Array.of(Kind)

    LayoutDefinition = Instance(::LayoutDefinition)

    LayoutInstance = Instance(::LayoutInstance)

    LayoutKind = ApplicationRecord.dry_pg_enum(:layout_kind)

    LIMIT_DEFAULT = 3

    LIMIT_MIN = 1

    LIMIT_MAX = 24

    LIMIT_RANGE = LIMIT_MIN..LIMIT_MAX

    LIMIT_CONSTRAINTS = { included_in: LIMIT_RANGE, gteq: LIMIT_MIN, lteq: LIMIT_MAX }.freeze

    Limit = Coercible::Integer.default(LIMIT_DEFAULT).constrained(**LIMIT_CONSTRAINTS)

    LimitWithFallback = Limit.fallback(LIMIT_DEFAULT)

    LinkListSelectionMode = ApplicationRecord.dry_pg_enum(:link_list_ordering_mode)

    OrderingDefinition = Instance(::Schemas::Orderings::Definition).constructor do |value|
      case value
      when ::Schemas::Orderings::Definition then value
      when ::Hash
        ::Schemas::Orderings::Definition.new(value)
      when nil, Dry::Core::Constants::Undefined
        ::Schemas::Orderings::Definition.new
      else
        raise Dry::Types::CoercionError, "invalid ordering definition input: #{value.inspect}"
      end
    end

    PropertyKind = Coercible::String.enum(
      "background",
      "boolean",
      "limit",
      "ordering_definition",
      "schema_component",
      "selection_mode",
      "selection_source",
      "selection_source_mode",
      "string",
      "variant"
    )

    SELECTION_SOURCE_SELF_PATTERN = /\Aself\z/

    SELECTION_SOURCE_ANCESTOR_PATTERN = /
    ancestors
    \.
    (?<ancestor_name>[a-z][a-z0-9_]*[a-z])
    /x

    SelectionSourceSelf = Coercible::String.constrained(eql: "self")

    SelectionSourceAncestor = Coercible::String.constrained(format: SELECTION_SOURCE_ANCESTOR_PATTERN)

    SELECTION_SOURCE_PATTERN = /\A
    (?:#{SELECTION_SOURCE_SELF_PATTERN})
    |
    (?:#{SELECTION_SOURCE_ANCESTOR_PATTERN})
    \z
    /x

    SelectionSource = Coercible::String.default("self").constrained(format: SELECTION_SOURCE_PATTERN)

    SlotKind = ::Types::TemplateSlotKindType.dry_type

    StrippedString = Coercible::String.constructor { _1.to_s.strip_heredoc.strip }

    TemplateDefinition = Instance(::TemplateDefinition)

    TemplateInstance = Instance(::TemplateInstance)
  end
end
