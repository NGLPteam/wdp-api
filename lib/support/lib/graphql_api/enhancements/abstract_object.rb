# frozen_string_literal: true

module Support
  module GraphQLAPI
    module Enhancements
      module AbstractObject
        extend ActiveSupport::Concern

        include Support::GraphQLAPI::ImageAttachmentSupport
        include Support::GraphQLAPI::PunditHelpers

        CACHEABLE = Support::Types.Interface(:cache_key)

        # @abstract
        def current_user_privileged?
          false
        end

        # @api private
        # @return [Object]
        def maybe_cache_expensive(depends_on_variables: true, expires_in: 10.minutes, force: current_user_privileged?)
          variable_hash = context.query.variables.to_h.hash

          key_parts = [
            "GQL",
            context.current_path.join(?.),
            rails_cache_key_for(object),
          ]

          key_parts << variable_hash if depends_on_variables

          key = key_parts.compact.join(?:)

          Rails.cache.fetch(key, expires_in:, force:) do
            yield
          end
        end

        # @api private
        # @param [#cache_key] value
        # @return [String, nil]
        def rails_cache_key_for(value)
          case value
          when GraphQL::Pagination::Connection
            rails_cache_key_for value.parent
          when CACHEABLE
            value.cache_key
          end
        end
      end
    end
  end
end
