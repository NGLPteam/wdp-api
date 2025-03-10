# frozen_string_literal: true

module Metadata
  module OAIDC
    module Elements
      class Date < Metadata::OAIDC::AbstractElement
        xml do
          root "date"
        end
      end
    end
  end
end
