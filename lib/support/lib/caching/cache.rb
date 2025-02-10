# frozen_string_literal: true

module Support
  module Caching
    # dry-effects provides a cache effect that is very useful, but has no fall-through
    # when not wrapped.
    #
    # This marries cache with the Reader effect to specify whether or not the cache
    # is active or not. It allows for safe evaluation of anything with the ability
    # to cache it in certain contexts.
    #
    # @api private
    class Cache
      include Dry::Effects::Handler.Cache(:vog_safe_cache)
      include Dry::Effects::Handler.Reader(:vog_safe_cache_active)
      include Dry::Effects.Cache(:vog_safe_cache, shared: true)
      include Dry::Effects.Reader(:vog_safe_cache_active, default: false)

      alias vog_safe_cache_active? vog_safe_cache_active

      private :cache
      private :with_cache

      def vog_cache(...)
        if vog_safe_cache_active?
          cache(...)
        else
          yield
        end
      end

      def with_vog_cache
        return yield if vog_safe_cache_active?

        with_vog_safe_cache_active true do
          with_cache do
            yield
          end
        end
      end

      class << self
        # @return [Support::Caching::Cache]
        def instance
          @instance ||= new
        end

        delegate :vog_cache, :with_vog_cache, to: :instance
      end
    end
  end
end
