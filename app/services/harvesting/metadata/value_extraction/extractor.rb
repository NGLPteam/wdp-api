# frozen_string_literal: true

module Harvesting
  module Metadata
    module ValueExtraction
      class Extractor
        include Dry::Effects::Handler.Resolve
        include Dry::Monads[:result, :validated, :list]
        include Dry::Monads::Do.for(:call)
        include Dry::Initializer[undefined: false].define -> do
          option :top_level_values, Harvesting::Metadata::ValueExtraction::Value::Map
          option :sets, Harvesting::Metadata::ValueExtraction::Set::Map
          option :values, Harvesting::Metadata::ValueExtraction::Value::PathMap
          option :paths, Harvesting::Types::Paths
          option :ordered_values, Harvesting::Metadata::ValueExtraction::Value::List
          option :struct_klass, Harvesting::Types.Inherits(Harvesting::Metadata::ValueExtraction::Struct)
        end
        include Shared::Typing

        # @param [Harvesting::Metadata::ExtractsValues] source
        # @return [Dry::Monads::Result]
        def call(source)
          context = Harvesting::Metadata::ValueExtraction::Context.new source

          result = context.wrap do
            each_value do |value|
              context.register_value! value.full_path, value.call(source)
            end
          end

          values = yield result

          Success struct_klass.new values
        end

        # Iterate over each value from a top-level approach in a dependency
        # guaranteed order. If A depends on B depends on C, it will iterate
        # as C, B, A.
        #
        # @yieldparam [Harvesting::Metadata::ValueExtraction::Value] value
        # @yieldreturn [void]
        # @return [void]
        def each_value
          return enum_for(__method__) unless block_given?

          ordered_values.each do |value|
            yield value
          end
        end

        # @api private
        class EmptyStruct < Harvesting::Metadata::ValueExtraction::Struct; end

        class << self
          # A default, empty extractor that pulls out no values.
          #
          # @return [Harvesting::Metadata::ValueExtraction::Extractor]
          def empty
            new(
              top_level_values: {},
              sets: {}, values: {},
              paths: [], ordered_values: [],
              struct_klass: EmptyStruct,
            )
          end
        end
      end
    end
  end
end
