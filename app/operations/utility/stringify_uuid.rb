# frozen_string_literal: true

module Utility
  class StringifyUuid
    include Dry::Monads[:do, :result]

    def call(ids)
      ids = yield AppTypes::IntList.try(ids).to_monad

      stringified = ids.map do |i|
        i.to_s(16).sub(/\A1/, "")
      end.join("-")

      AppTypes::UUID.try(stringified).to_monad
    end
  end
end
