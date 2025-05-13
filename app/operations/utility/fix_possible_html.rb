# frozen_string_literal: true

module Utility
  # @see Utility::HTMLFixer
  class FixPossibleHTML < Support::SimpleServiceOperation
    service_klass Utility::HTMLFixer
  end
end
