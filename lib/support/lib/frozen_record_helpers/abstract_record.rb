# frozen_string_literal: true

module Support
  module FrozenRecordHelpers
    # An abstract class that ties some integrations together with dry-schema,
    # arel, and Rails in general to FrozenRecord.
    #
    # @abstract
    class AbstractRecord < FrozenRecord::Base
      extend Dry::Core::ClassAttributes

      self.abstract_class = true

      include ArelHelpers

      defines :default_attributes, type: Types::DefaultAttributes
      defines :default_sql_values, type: Types::DefaultSQLValues
      defines :schema, type: Types::Schema.optional

      default_attributes({})

      default_sql_values []

      schema nil

      def slice(*keys)
        keys.flatten.index_with do |key|
          public_send key
        end
      end

      # @param [Symbol] key
      # @return [Arel::Nodes::Node]
      def to_sql_value(key)
        arel_quote self[key]
      end

      def to_upsert
        slice(*self.class.default_sql_values)
      end

      # @param [<Symbol>] key
      # @return [<Arel::Nodes::Node>]
      def to_values(*keys)
        keys.flatten!

        if keys.blank?
          return [] if self.class.default_sql_values.blank?

          return to_values(*self.class.default_sql_values)
        end

        keys.map do |key|
          to_sql_value key
        end
      end

      private

      def arel_table
        @arel_table ||= ->(key) { to_sql_value(key) }
      end

      def arel_column_matcher
        @arel_column_matcher ||= ->(o) { attributes.key?(o.to_s) }
      end

      # @param [#to_json] value
      # @return [Arel::Nodes::Quoted]
      def arel_quote_json(value)
        arel_quote value.to_json
      end

      class << self
        # @note We repurpose this built-in method to apply our schema
        def assign_defaults!(record)
          return super if schema.blank?

          record = record.deep_stringify_keys

          record.reverse_merge!(default_attributes.deep_stringify_keys)

          result = schema.call record

          return result.to_monad.value! if result.failure?

          result.to_h.stringify_keys
        end

        def default_attributes!(**defaults)
          default_attributes defaults.deep_stringify_keys
        end

        def schema!(types: ::Shared::TypeRegistry, &block)
          defined = Dry::Schema.Params do
            config.types = types

            instance_eval(&block)
          end

          schema defined
        end

        # @return [<Hash>]
        def to_upsert
          all.map(&:to_upsert)
        end

        # @param [<Symbol>] key
        # @return [Arel::Nodes::ValuesList]
        def to_values_list(*keys)
          sqlized = to_values(*keys).map do |row|
            row.map do |value|
              case value
              when Arel::Nodes::Quoted then value.expr
              else
                value
              end
            end
          end

          Arel::Nodes::ValuesList.new sqlized
        end

        # @param [<Symbol>] key
        # @return [<<Arel::Nodes::Node>>]
        def to_values(*keys)
          all.map do |record|
            record.to_values(*keys)
          end
        end
      end
    end
  end
end
