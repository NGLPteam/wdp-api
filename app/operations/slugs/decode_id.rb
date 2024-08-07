# frozen_string_literal: true

module Slugs
  class DecodeId
    include Dry::Monads[:do, :result]
    include MeruAPI::Deps[:hashids, stringify_uuid: "utility.stringify_uuid"]

    # @param [String] encoded_id
    # @return [Dry::Monads::Result(String)]
    def call(encoded_id)
      id = hashids.decode encoded_id

      uuid = yield stringify_uuid.call id

      Success uuid
    rescue Hashids::InputError => e
      Failure[:unable_to_unhash, e.message]
    end
  end
end
