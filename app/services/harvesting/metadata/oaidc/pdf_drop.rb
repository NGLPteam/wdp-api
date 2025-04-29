# frozen_string_literal: true

module Harvesting
  module Metadata
    module OAIDC
      class PDFDrop < ::Liquid::Drop
        # @param [String, nil] url
        def initialize(url = nil)
          @url = url

          @exists = @url.present?
        end

        # @return [Boolean]
        attr_reader :exists

        # @return [String, nil]
        attr_reader :url
      end
    end
  end
end
