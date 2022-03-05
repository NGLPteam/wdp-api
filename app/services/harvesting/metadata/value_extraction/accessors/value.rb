# frozen_string_literal: true

module Harvesting
  module Metadata
    module ValueExtraction
      module Accessors
        # Access an attribute from the source via a specified attribute name.
        #
        # The prospective attribute must be publicly-accessible.
        class Value < Harvesting::Metadata::ValueExtraction::Accessor
          include Dry::Effects.Resolve(:resolve_dependency)

          param :path, Harvesting::Types::Path

          # @param [Object] _source not used for dependency resolution
          # @return [Dry::Monads::Result]
          def extract(_source)
            resolve_dependency.call(path)
          end
        end
      end
    end
  end
end
