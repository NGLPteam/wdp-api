# frozen_string_literal: true

module Metadata
  module METS
    module Elements
      # @note Not extensively implemented.
      class Stream < ::Metadata::METS::Common::AbstractMapper
        xml do
          root "stream", mixed: true

          namespace "http://www.loc.gov/METS/"
        end
      end
    end
  end
end
