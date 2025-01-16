# frozen_string_literal: true

module Templates
  module MDX
    # For tags that simply accept any string content
    # and return it (stripped) in the inner HTML of
    # the generated MDX tag.
    module ContentWrapper
      extend ActiveSupport::Concern

      EMPTY_CHILD_SELECTOR = %{[display="empty"]}

      EMPTY_CONTENT = "This element had no content."

      included do
        defines :display_checks_children, type: Templates::Types::Bool

        option :content, Templates::Types::Coercible::String, default: proc { "" }

        display_checks_children false
      end

      # @return ["present", "empty"]
      attr_reader :display

      # @return [Boolean]
      attr_reader :empty

      alias empty? empty

      def prepare
        @display = derive_display_mode

        @empty = display == "empty"

        super
      end

      def build_attributes
        super.merge(display:)
      end

      def build_inner_html
        if empty?
          EMPTY_CONTENT
        else
          content.strip
        end
      end

      private

      def display_checks_children?
        self.class.display_checks_children
      end

      # @return ["present", "empty"]
      def derive_display_mode
        has_empty_content? ? "empty" : "present"
      end

      def has_empty_content?
        content.blank? || has_empty_children?
      end

      def has_empty_children?
        return false unless display_checks_children?

        fragment = Nokogiri::HTML.fragment(content)

        fragment.at_css(EMPTY_CHILD_SELECTOR).present?
      end
    end
  end
end
