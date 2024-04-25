# frozen_string_literal: true

module Support
  module Utility
    class IntifyUuid
      include Dry::Monads[:do, :result]

      # @param [String] uuid
      # @return [<Integer>]
      def call(uuid)
        uuid = yield Support::GlobalTypes::UUID.try(uuid).to_monad

        ids = uuid.split(?-).map do |s|
          # Handle initial 0s
          "1#{s}".to_i(16)
        end

        Support::GlobalTypes::IntList.try(ids).to_monad
      end
    end
  end
end
