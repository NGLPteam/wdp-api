# frozen_string_literal: true

module Utility
  class IntifyUuid
    include Dry::Monads[:do, :result]

    # @param [String] uuid
    # @return [<Integer>]
    def call(uuid)
      uuid = yield AppTypes::UUID.try(uuid).to_monad

      ids = uuid.split(?-).map do |s|
        # Handle initial 0s
        "1#{s}".to_i(16)
      end

      AppTypes::IntList.try(ids).to_monad
    end
  end
end
