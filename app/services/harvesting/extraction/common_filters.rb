# frozen_string_literal: true

module Harvesting
  module Extraction
    module CommonFilters
      # @param [#to_s] input
      # @return [ActiveSupport::SafeBuffer]
      def unescape_html(input)
        CGI.unescapeHTML(input.to_s).html_safe
      end
    end
  end
end
