# frozen_string_literal: true

module Testing
  module Merced
    # @api private
    # @operation
    class ScaffoldCommunity
      include Dry::Monads[:result]
      include WDPAPI::Deps[upsert: "communities.upsert"]
      prepend HushActiveRecord

      # @return [Dry::Monads::Success(Community)]
      def call
        upsert "ucm", title: "UC Merced"
      end
    end
  end
end
