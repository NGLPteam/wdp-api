# frozen_string_literal: true

module Templates
  module MDX
    # @abstract
    class AbstractBuilder < Support::HookBased::Actor
      extend Dry::Core::ClassAttributes
      extend Dry::Initializer

      include ActionView::Helpers::TagHelper
      include Dry::Core::Constants

      defines :tag_name, type: Templates::Types::String.constrained(filled: true)

      tag_name "MDXTag"

      standard_execution!

      # @return [{ Symbol => String }]
      attr_reader :attributes

      # @return [String]
      attr_reader :inner_html

      # @return [ActiveSupport::SafeBuffer]
      attr_reader :output

      # @return [Dry::Monads::Success(ActiveSupport::SafeBuffer)]
      def call
        run_callbacks :execute do
          yield prepare!

          yield render!
        end

        Success output
      end

      wrapped_hook! def prepare
        super
      end

      wrapped_hook! def render
        @attributes = build_attributes

        @inner_html = build_inner_html.to_s.html_safe

        @output = content_tag(tag_name, inner_html, **attributes)

        super
      end

      def tag_name
        self.class.tag_name
      end

      private

      def build_attributes
        EMPTY_HASH
      end

      def build_inner_html
        "".html_safe
      end
    end
  end
end
