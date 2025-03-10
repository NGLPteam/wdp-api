# frozen_string_literal: true

module Metadata
  module OAIDC
    module Elements
      class Creator < Metadata::OAIDC::AbstractElement
        xml do
          root "creator"
        end
      end
    end
  end
end
