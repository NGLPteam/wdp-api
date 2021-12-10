# frozen_string_literal: true

module Resolvers
  module FirstMatching
    extend ActiveSupport::Concern

    include Resolvers::EnhancedResolver

    included do
      extension Resolvers::FirstMatchingExtension, resolver: self
    end
  end
end
