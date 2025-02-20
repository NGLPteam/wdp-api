# frozen_string_literal: true

module Schemas
  module Orderings
    module OrderBuilder
      extend Dry::Container::Mixin

      # @api private
      COMPONENT_FORMAT = Schemas::Orderings::Types::COMPONENT_FORMAT

      SUPPORTED_SCHEMA_PROPERTY_TYPES = %w[
        boolean
        date
        email
        float
        integer
        string
        timestamp
        variable_date
      ].freeze

      STATIC_KEYS = Regexp.union(StaticOrderableProperty.pluck(:path))

      STATIC_PATTERN = /\A#{STATIC_KEYS}\z/

      ANCESTOR_STATIC_KEYS = Regexp.union(StaticAncestorOrderableProperty.pluck(:base_path))

      ANCESTOR_STATIC_PATTERN = /\A
      ancestors
      \.
      (?<ancestor_name>#{COMPONENT_FORMAT})
      \.
      (?<path>#{ANCESTOR_STATIC_KEYS})
      \z/x

      PROPS_PATTERN = /\A
      props
      \.
      (?<path>
        (?:#{COMPONENT_FORMAT}+)
        (?:\.#{COMPONENT_FORMAT}+?)?
      )
      (?<type>\##{Regexp.union(SUPPORTED_SCHEMA_PROPERTY_TYPES)})?
      \z/x

      ANCESTOR_PROPS_PATTERN = /\A
      ancestors
      \.
      (?<ancestor_name>#{COMPONENT_FORMAT})
      \.
      props
      \.
      (?<path>
        (?:#{COMPONENT_FORMAT}+)
        (?:\.#{COMPONENT_FORMAT}+?)?
      )
      (?<type>\##{Regexp.union(SUPPORTED_SCHEMA_PROPERTY_TYPES)})?
      \z/x

      PATTERN = Regexp.union(STATIC_PATTERN, ANCESTOR_STATIC_PATTERN, PROPS_PATTERN, ANCESTOR_PROPS_PATTERN)
    end
  end
end
