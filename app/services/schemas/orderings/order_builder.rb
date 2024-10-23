# frozen_string_literal: true

module Schemas
  module Orderings
    module OrderBuilder
      extend Dry::Container::Mixin

      COMPONENT_FORMAT = /[a-z][a-z0-9_]*?[a-z0-9]/

      StaticOrderableProperty.each do |property|
        register property.path do
          property.order_builder
        end
      end

      STATIC_KEYS = Regexp.union(keys)

      STATIC_PATTERN = /\A#{STATIC_KEYS}\z/

      PROPS_PATTERN = /\A
      props
      \.
      (?:
        (?:#{COMPONENT_FORMAT}+)
        (?:\.#{COMPONENT_FORMAT}+?)?
      )
      (?:\##{Regexp.union(::EntityOrderableProperty::SUPPORTED_PROPERTY_TYPES.map(&:to_s))})?
      \z/x

      PATTERN = Regexp.union(STATIC_PATTERN, PROPS_PATTERN)

      namespace :props do
        register ?* do
          BySchemaProperty.new
        end
      end
    end
  end
end
