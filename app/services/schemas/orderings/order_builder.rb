# frozen_string_literal: true

module Schemas
  module Orderings
    module OrderBuilder
      extend Dry::Container::Mixin

      StaticOrderableProperty.each do |property|
        register property.path do
          property.order_builder
        end
      end

      STATIC_KEYS = Regexp.union(keys)

      PATTERN = /\A
      (?:#{STATIC_KEYS})
      |
      (?:props\.(?:[^.]+)(?:\.[^.]+)?)
      \z/x.freeze

      namespace :props do
        register ?* do
          BySchemaProperty.new
        end
      end
    end
  end
end
