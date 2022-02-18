# frozen_string_literal: true

module Schemas
  module Properties
    # Types specific to working with schema property classes.
    module Types
      include Dry.Types

      # @api private
      #
      # @see Function
      KNOWN_FUNCTIONS = %w[content metadata presentation sorting unspecified].freeze

      private_constant :KNOWN_FUNCTIONS

      HypertextURL = String.constrained(http_uri: true)

      # The shape of the object that backs a `URL` schema property.
      #
      # @see Schemas::Properties::Scalar::URL
      URLShape = Hash.schema(
        href: HypertextURL,
        label: String.default("URL"),
        title?: String.default("").optional,
      ).with_key_transform(&:to_sym)

      NormalizedURL = URLShape.constructor do |value|
        case value
        when Schemas::Properties::Types::URLShape
          Schemas::Properties::Types::URLShape[value]
        when HypertextURL
          { href: value, label: "URL", title: "" }
        end
      end

      Registry = Dry::Schema::TypeContainer.new

      Registry.register "params.collected_reference", Schemas::References::Types::Collected

      Registry.register "params.scalar_reference", Schemas::References::Types::Scalar

      Registry.register "params.full_text", FullText::Types::NormalizedReference

      Registry.register "params.variable_date", VariablePrecisionDate::ParseType

      Registry.register "params.url", URLShape

      # A meta type for matching dry-types, used to enforce setting a base type
      # within scalar property classes.
      #
      # @see Schemas::Properties::Scalar::Base.base_type
      BaseType = Nominal(Dry::Types::Type).constructor do |value|
        case value
        when :any then Any
        when :boolean then Params::Bool
        when Dry::Types::Type then value
        when PossibleParamTypeName then Registry["params.#{value}"]
        end
      end

      # A defined function for the property.
      Function = String.enum(*KNOWN_FUNCTIONS)

      # A logical grouping for the kind of property.
      #
      # There's an associated enum type in the database: `schema_property_kind`.
      Kind = Coercible::String.enum("complex", "group", "reference", "simple")

      # @api private
      #
      # An enum type that matches the name of any default `dry-types` Params type.
      PossibleParamTypeName = Registry.keys.grep(/\Aparams\./).then do |types|
        unprefixed_types = types.map { |type| type.sub(/\Aparams\./, "") }

        Coercible::String.enum(*unprefixed_types)
      end

      # A meta type for matching the _schema_ type used by scalar properties
      # when validating within contracts.
      #
      # @see Schemas::Properties::Scalar::Base.base_type
      SchemaType = Instance(Dry::Types::Type) | String | Symbol
    end
  end
end
