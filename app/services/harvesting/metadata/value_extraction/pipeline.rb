# frozen_string_literal: true

module Harvesting
  module Metadata
    module ValueExtraction
      # @abstract
      class Pipeline < Dry::Transformer::Pipe
        import Harvesting::Metadata::ValueExtraction::Functions

        class << self
          # Generate a pipeline based on the passed-in block.
          #
          # It builds a subclass and instantiates it immediately,
          # since we do not need to instantiate transformers on
          # each extraction.
          #
          # @return [Harvesting::Metadata::ValueExtraction::Pipeline]
          def make!(&block)
            Class.new(self) do
              define!(&block)
            end.new
          end
        end
      end
    end
  end
end
