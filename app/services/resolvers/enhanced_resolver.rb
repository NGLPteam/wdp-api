# frozen_string_literal: true

module Resolvers
  module EnhancedResolver
    extend ActiveSupport::Concern

    # @return [Integer]
    def count
      @count ||= fetch_count
    end

    # @return [ActiveRecord::Relation]
    def raw_scope
      @search.instance_variable_get(:@scope)
    end

    # @return [Integer]
    def unfiltered_count
      @unfiltered_count ||= fetch_unfiltered_count
    end

    # @return [ActiveRecord::Relation]
    def unfiltered_scope
      raw_scope
    end

    private

    def fetch_count
      fetch_results.count_from_subquery(strip_order: true)
    end

    def fetch_unfiltered_count
      unfiltered_scope.count_from_subquery(strip_order: true)
    end
  end
end
