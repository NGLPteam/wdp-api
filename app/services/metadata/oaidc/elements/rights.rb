# frozen_string_literal: true

module Metadata
  module OAIDC
    module Elements
      class Rights < Metadata::OAIDC::AbstractElement
        xml do
          root "rights"
        end
      end
    end
  end
end
