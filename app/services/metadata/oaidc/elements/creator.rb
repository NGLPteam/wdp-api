# frozen_string_literal: true

module Metadata
  module OAIDC
    module Elements
      class Creator < Metadata::OAIDC::AbstractElement
        include ::Metadata::OAIDC::Naming::HasName

        xml do
          root "creator"
        end
      end
    end
  end
end
