# frozen_string_literal: true

module Metadata
  module OAIDC
    module Elements
      class Subject < Metadata::OAIDC::AbstractElement
        xml do
          root "subject"
        end
      end
    end
  end
end
