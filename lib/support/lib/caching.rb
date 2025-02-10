# frozen_string_literal: true

module Support
  # A portable, abstract caching solution for requests, rendering, ingestions, etc.
  # Anything where an expensive thing might be accessed multiple times but fetched
  # from the database in different orders.
  module Caching
    class << self
      # @see Support::Caching::Cache#with_vog_cache
      def with_vog_cache(...)
        Support::Caching::Cache.with_vog_cache(...)
      end
    end
  end
end
