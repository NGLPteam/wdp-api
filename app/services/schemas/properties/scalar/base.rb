# frozen_string_literal: true

module Schemas
  module Properties
    module Scalar
      # @abstract
      class Base < Schemas::Properties::BaseDefinition
        include ActiveSupport::Configurable

        attribute :label, :string
        attribute :function, :string
        attribute :mappings, Schemas::Properties::MappingDefinition.to_array_type
        attribute :required, :boolean, default: proc { false }

        config.array = false
        config.base_type = Dry::Types["any"]
        config.schema_predicates = {}

        def add_to_schema!(context)
          return if exclude_from_schema?

          apply_schema_type_to build_schema_macro context
        end

        def actually_required?
          !exclude_from_schema? && required
        end

        # @!attribute [r] dig_path
        # An array of strings suitable for use with `Enumerable#dig`, grabbing
        # the property's group's `path` when {#nested? nested}.
        # @return [<String>]
        def dig_path
          nested? ? [parent.path, path] : [path]
        end

        # @!attribute [r] dry_type
        # @return [Dry::Types::Type]
        memoize def dry_type
          build_dry_type
        end

        # @!attribute [r] full_path
        # The full `"dot.path"` for the property, based on whether the property is {#nested? nested}.
        # @return [String]
        def full_path
          nested? ? "#{parent.path}.#{path}" : path
        end

        # Whether this property
        def has_default?
          respond_to?(:default) && !default.nil?
        end

        # Whether this property is nested under a {Schemas::Properties::GroupDefinition group}.
        def nested?
          parent.kind_of?(Schemas::Properties::GroupDefinition)
        end

        # A predicate to detect if we should try to coerce a value
        # in the `before(:value_coercer)` processing step of dry-schema.
        #
        # @see Schemas::Properties::CompileSchema
        # @see #normalize_schema_value_before_coercer
        def might_normalize_value_before_coercion?
          return false if exclude_from_schema?

          return true if has_default?

          false
        end

        # A hook method used to calculate the default if no value is provided, or if
        # necessary, perform more complex coercions than dry-schema supports. Chiefly,
        # it's used by {Schemas::Properties::Scalar::Reference reference properties}
        # to perform model lookups with a variety of supported input types.
        #
        # @abstract
        # @see Schemas::Properties::CompileSchema
        def normalize_schema_value_before_coercer(context)
          if has_default? && context[:raw].nil?
            default
          else
            context[:raw]
          end
        end

        # @!attribute [r] schema_predicates
        # @return [{ Symbol => Object }]
        memoize def schema_predicates
          build_schema_predicates
        end

        # Determine if a property should be excluded
        # because of some type of invalidity.
        def exclude_from_schema?
          return true if config.schema_type.blank?

          false
        end

        # @param [Schemas::Properties::Context] context
        # @return [Dry::Monads::Result]
        def read_value_from(context)
          extracted_value = extract_raw_value_from context

          validated_value = validate_raw_value extracted_value

          normalize_read_value validated_value
        end

        # @api private
        # @abstract
        # @param [Schemas::Properties::Context] context
        # @return [Object]
        def extract_raw_value_from(context)
          context.values.dig(*dig_path)
        end

        # @api private
        # @abstract
        # @return [Object]
        def validate_raw_value(extracted_value)
          case extracted_value
          when config.base_type, Dry::Types["array"].of(config.base_type) then extracted_value
          end
        end

        # @api private
        # @abstract
        # @return [Object]
        def normalize_read_value(value)
          config.array ? Array(value) : value
        end

        def write_values_within!(context)
          context.copy_value! path
        end

        private

        def apply_nil_coercion(type)
          if type.default?
            type.constructor do |value|
              value.nil? ? Dry::Types::Undefined : value
            end
          else
            type
          end
        end

        def apply_schema_default(type)
          if has_default?
            type.default { default }
          else
            type
          end
        end

        # @abstract
        def apply_schema_type_to(macro)
          return apply_schema_type_for_array_to(macro) if config.array

          apply_schema_type_for_default_to(macro)
        end

        def apply_schema_type_for_array_to(macro)
          array_element_macros = build_array_element_macros

          if actually_required?
            macro.array(config.schema_type, **schema_predicates) do
              array? > each(*array_element_macros)
            end
          else
            macro.maybe(:array, **schema_predicates) do
              array? > each(*array_element_macros)
            end
          end
        end

        def apply_schema_type_for_default_to(macro)
          if actually_required? && fillable_schema_type?
            macro.filled(config.schema_type, **schema_predicates)
          elsif actually_required?
            macro.value(config.schema_type, **schema_predicates)
          else
            macro.maybe(config.schema_type, **schema_predicates)
          end
        end

        def build_array_element_macros
          [*Array(config.array_element_macros), build_array_element_predicates].select(&:present?)
        end

        def build_array_element_predicates
          {}
        end

        # @return [Dry::Schema::Macros::Required]
        # @return [Dry::Schema::Macros::Optional]
        def build_schema_macro(context)
          if actually_required?
            context.required(key)
          else
            context.optional(key)
          end
        end

        # @return [Object]
        def build_dry_type
          apply_nil_coercion apply_schema_default config.base_type
        end

        def fillable_schema_type?
          config.schema_type == :string
        end

        # @abstract
        # @return [{ Symbol => Object }]
        def build_schema_predicates
          base_schema_predicates.merge(config.schema_predicates)
        end

        # @abstract
        # @return [{ Symbol => Object }]
        def base_schema_predicates
          {}
        end

        class << self
          def array!(*array_element_macros)
            config.array = true

            config.array_element_macros = array_element_macros.flatten
          end

          def schema_type!(value)
            config.schema_type = value

            config.base_type = AppTypes::PropertyType[value]
          end
        end
      end
    end
  end
end
