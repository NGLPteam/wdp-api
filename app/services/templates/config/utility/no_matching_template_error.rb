# frozen_string_literal: true

module Templates
  module Config
    module Utility
      # An error raised when there is no matching template for the given input.
      class NoMatchingTemplateError < PolymorphicTemplateError; end
    end
  end
end
