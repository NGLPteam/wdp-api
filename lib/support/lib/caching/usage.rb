# frozen_string_literal: true

module Support
  module Caching
    # Include in any class for an easy, safe caching option that will cache expensive
    # operations that have been wrapped by {Support::Caching.with_vog_cache}.
    #
    # If they haven't been wrapped, they will evaluate as normal and not be cached at all.
    module Usage
      extend ActiveSupport::Concern

      # @see Support::Caching::Cache#vog_cache
      def vog_cache(...)
        Support::Caching::Cache.vog_cache(...)
      end
    end
  end
end
