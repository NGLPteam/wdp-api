# frozen_string_literal: true

module DSL
  module WithDefaultOptions
    extend ActiveSupport::Concern

    included do
      @default_options = {}
    end

    class_methods do
      def default_options(options)
        @default_options = options
      end

      def option_defaults
        @default_options
      end
    end

    def with_default_options(options)
      self.class.option_defaults.with_indifferent_access.merge(options)
    end

    def default_options
      self.class.option_defaults
    end
  end
end
