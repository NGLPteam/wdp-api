# frozen_string_literal: true

module Metadata
  module OAIDC
    module Elements
      class Identifier < Metadata::OAIDC::AbstractElement
        xml do
          root "identifier"
        end
      end
    end
  end
end
