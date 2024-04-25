# frozen_string_literal: true

module Support
  module Slugs
    class DecodeId
      include Dry::Monads[:result, :do]
      include Support::Deps[:hashids, stringify_uuid: "utility.stringify_uuid"]

      # @param [String] encoded_id
      # @return [Dry::Monads::Result(String)]
      def call(encoded_id)
        id = hashids.decode encoded_id

        uuid = yield stringify_uuid.call id

        Success uuid
      rescue ::Hashids::InputError => e
        Failure[:unable_to_unhash, e.message]
      end
    end
  end
end
