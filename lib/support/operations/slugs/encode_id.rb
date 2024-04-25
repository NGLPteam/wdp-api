# frozen_string_literal: true

module Support
  module Slugs
    class EncodeId
      include Dry::Monads[:result, :do]
      include Support::Deps[:hashids, intify_uuid: "utility.intify_uuid"]

      # @param [String] uuid
      # @return [Dry::Monads::Result(String)]
      def call(uuid)
        ids = yield intify_uuid.call(uuid)

        Success hashids.encode ids
      end
    end
  end
end
