# frozen_string_literal: true

module Harvesting
  module Metadata
    module ValueExtraction
      class Context
        include Dry::Container::Mixin
        include Dry::Effects::Handler.Resolve
        include Dry::Initializer[undefined: false].define -> do
          param :source, Harvesting::Types.Instance(Harvesting::Metadata::ExtractsValues)
        end

        # @return [Harvesting::Metadata::ValueExtraction::Values]
        attr_reader :value_registry

        delegate :register_value!, to: :value_registry

        def initialize(...)
          super

          @value_registry = Values.new

          register :resolve_dependencies, @value_registry.method(:resolve_dependencies), call: false
          register :resolve_dependency, @value_registry.method(:resolve_dependency), call: false
          register :source, source

          source.enhance_extraction_context self
        end

        # @api private
        #
        # @see Harvesting::Metadata::ValueExtraction::Values#to_monad
        # @return [Dry::Monads::Result]
        def wrap(&)
          provide self do
            yield
          end

          value_registry.to_monad
        end
      end
    end
  end
end
