# frozen_string_literal: true

module Metadata
  module OAIDC
    module Elements
      class Contributor < Metadata::OAIDC::AbstractElement
        include ::Metadata::OAIDC::Naming::HasName

        xml do
          root "contributor"
        end
      end
    end
  end
end
