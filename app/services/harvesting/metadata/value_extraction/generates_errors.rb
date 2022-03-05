# frozen_string_literal: true

module Harvesting
  module Metadata
    module ValueExtraction
      module GeneratesErrors
        extend ActiveSupport::Concern

        included do
          extend Dry::Core::ClassAttributes

          defines :error_context, type: Harvesting::Types::Identifier

          error_context :default
        end

        # @return [Harvesting::Metadata::ValueExtraction::Error]
        def extraction_error!(code, context: self.class.error_context, message: nil, **metadata)
          Harvesting::Metadata::ValueExtraction::Error.new(code: code, context: context, message: message, metadata: metadata)
        end
      end
    end
  end
end
