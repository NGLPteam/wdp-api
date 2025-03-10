# frozen_string_literal: true

module Metadata
  module OAIDC
    module Elements
      class Publisher < Metadata::OAIDC::AbstractElement
        xml do
          root "publisher"
        end
      end
    end
  end
end
