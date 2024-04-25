# frozen_string_literal: true

module Support
  module Utility
    class StringifyUuid
      include Dry::Monads[:do, :result]

      def call(ids)
        ids = yield Support::GlobalTypes::IntList.try(ids).to_monad

        stringified = ids.map do |i|
          i.to_s(16).sub(/\A1/, "")
        end.join(?-)

        Support::GlobalTypes::UUID.try(stringified).to_monad
      end
    end
  end
end
