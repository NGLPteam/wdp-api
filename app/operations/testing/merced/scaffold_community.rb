# frozen_string_literal: true

module Testing
  module Merced
    # @api private
    # @operation
    class ScaffoldCommunity
      include WDPAPI::Deps["communities.upsert_by_title"]
      prepend HushActiveRecord

      # @return [Dry::Monads::Success(Community)]
      def call
        upsert_by_title.call("UC Merced")
      end
    end
  end
end
