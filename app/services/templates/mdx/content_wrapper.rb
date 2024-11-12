# frozen_string_literal: true

module Templates
  module MDX
    # For tags that simply accept any string content
    # and return it (stripped) in the inner HTML of
    # the generated MDX tag.
    module ContentWrapper
      extend ActiveSupport::Concern

      included do
        option :content, Templates::Types::String, default: proc { "" }
      end

      def build_inner_html
        content.strip
      end
    end
  end
end
