# frozen_string_literal: true

module Metadata
  module OAIDC
    module Elements
      class Format < Metadata::OAIDC::AbstractElement
        xml do
          root "format"
        end

        def pdf?
          content == "application/pdf"
        end
      end
    end
  end
end
