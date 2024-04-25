# frozen_string_literal: true

module Resolvers
  module Enhancements
    # A concern that applies a page number extension to the current resolver.
    #
    # @see Resolvers::Enhancements::PageNumberExtension
    module PageBasedPagination
      extend ActiveSupport::Concern

      included do
        extension Resolvers::Enhancements::PageNumberExtension, resolver: self
      end
    end
  end
end
