# frozen_string_literal: true

module Schemas
  module Properties
    module References
      module Entities
        module Scopes
          # These methods are used to query the scope's `origin`.
          #
          # Unless the type {HasOrigin}, it is assumed to be `"self"`.
          module OriginPredicates
            extend ActiveSupport::Concern

            # @!attribute [r] origin
            # @return ["self"]
            def origin
              "self"
            end

            def from_ancestor?
              Types::AncestorOrigin.valid?(origin)
            end

            def from_community?
              origin == "community"
            end

            def from_parent?
              origin == "from_parent"
            end

            def from_self?
              origin == "self"
            end

            def static_origin?
              Types::StaticOrigin.valid? origin
            end
          end
        end
      end
    end
  end
end
