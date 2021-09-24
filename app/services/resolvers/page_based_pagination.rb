# frozen_string_literal: true

module Resolvers
  module PageBasedPagination
    extend ActiveSupport::Concern

    included do
      extension Resolvers::PageNumberExtension, resolver: self
    end
  end
end
