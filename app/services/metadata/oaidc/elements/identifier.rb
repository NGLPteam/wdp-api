# frozen_string_literal: true

module Metadata
  module OAIDC
    module Elements
      class Identifier < Metadata::OAIDC::AbstractElement
        xml do
          root "identifier"
        end

        def doi?
          ::Entities::Types::DOI_PATTERN.match?(content)
        end
      end
    end
  end
end
