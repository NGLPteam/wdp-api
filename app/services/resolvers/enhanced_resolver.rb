# frozen_string_literal: true

module Resolvers
  module EnhancedResolver
    extend ActiveSupport::Concern

    # @return [ActiveRecord::Relation]
    def raw_scope
      @search.instance_variable_get(:@scope)
    end
  end
end
