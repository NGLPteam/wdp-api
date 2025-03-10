# frozen_string_literal: true

module Metadata
  module OAIDC
    module Elements
      class Title < Metadata::OAIDC::AbstractElement
        xml do
          root "title"
        end
      end
    end
  end
end
