# frozen_string_literal: true

module Harvesting
  module Metadata
    module ValueExtraction
      module DSL
        # Build a mapping of value extraction sets
        class Builder
          include Dry::Effects::Handler.Resolve
          include Dry::Initializer[undefined: false].define -> do
            param :klass, Harvesting::Types::Class
          end
          include BuildsValues

          def initialize(*)
            super

            @sets = {}
            @mods = []
            @set_mods = {}
          end

          # @return [Harvesting::Metadata::ValueExtraction::Extractor]
          def build(&block)
            provisions = { builder: self }

            provide provisions do
              instance_eval(&block)
            end

            finalize
          end

          # @!group DSL Methods

          # @return [void]
          def on_struct(&block)
            @mods << block
          end

          # Define a set with a DSL.
          #
          # @see Harvesting::Metadata::ValueExtraction::DSL::SetBuilder
          # @param [Harvesting::Types::Identifier] id
          # @return [void]
          def set(id, &block)
            set = DSL::SetBuilder.new(id).build(&block)

            raise "existing set" if @sets[set.identifier].present?

            @sets[set.identifier] = set
          end

          # @!endgroup

          # @return [{ String => <Proc> }]
          attr_reader :set_mods

          private

          # @return [Harvesting::Metadata::ValueExtraction::Extractor]
          def finalize
            options = { top_level_values: @values, sets: @sets }

            values, struct_klass = flatten_values_and_build_struct

            options[:values] = values
            options[:struct_klass] = struct_klass

            each_node = ->(&block) { values.each_key(&block) }

            each_child = ->(key, &block) do
              values.fetch(key).dependencies.each(&block)
            rescue KeyError
              # :nocov:
              raise "Unknown value dependency: #{key}"
              # :nocov:
            end

            paths = options[:paths] = TSort.tsort each_node, each_child

            options[:ordered_values] = paths.map { |path| values.fetch path }

            return Harvesting::Metadata::ValueExtraction::Extractor.new options
          end

          # @return [[{ String => Harvesting::Metadata::ValueExtraction::Value }, Class]]
          def flatten_values_and_build_struct
            collected = ::PropertyHash.new

            struct = Class.new(Harvesting::Metadata::ValueExtraction::Struct)

            klass.const_set :ExtractedValues, struct

            @values.each_value do |value|
              collected[value.full_path] = value

              value.expose_on_struct! struct
            end

            set_mods = @set_mods

            @sets.each_value do |set|
              struct.attribute set.identifier, Harvesting::Metadata::ValueExtraction::Struct do
                set.each_value do |value|
                  collected[value.full_path] = value

                  value.expose_on_struct! self
                end

                set_mods[set.identifier].each do |mod|
                  class_eval(&mod)
                end
              end
            end

            @mods.each do |mod|
              struct.class_eval(&mod)
            end

            [collected.to_flat_hash, struct]
          end
        end
      end
    end
  end
end
