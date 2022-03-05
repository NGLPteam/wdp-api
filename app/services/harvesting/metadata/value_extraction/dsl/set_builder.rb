# frozen_string_literal: true

module Harvesting
  module Metadata
    module ValueExtraction
      module DSL
        class SetBuilder
          include Dry::Effects::Handler.Resolve
          include Dry::Effects.Resolve(:builder)
          include Dry::Initializer[undefined: false].define -> do
            param :identifier, Harvesting::Types::Identifier
          end
          include BuildsValues

          def initialize(*)
            super

            builder.set_mods[identifier] = []
          end

          def build(&block)
            provide(set: self) do
              instance_eval(&block)
            end

            Harvesting::Metadata::ValueExtraction::Set.new(identifier, @values)
          end

          # Modify the set-specific struct with a block.
          #
          # @return [void]
          def on_struct(&block)
            set_mods << block
          end

          private

          def set_mods
            builder.set_mods[identifier]
          end
        end
      end
    end
  end
end
