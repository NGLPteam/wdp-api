# frozen_string_literal: true

module Harvesting
  module Logs
    # @abstract
    class Base
      extend Dry::Initializer

      include Redis::Objects

      param :model, Support::Models::Types::Model

      delegate :id, to: :model, prefix: true

      redis_id_field :model_id

      list :messages, marshal: true, maxlength: 10_000,
        expireat: proc { 1.day.from_now }

      def log(message, tags: [], level: nil)
        obj = { message:, time: Time.current, tags: tags.presence, level: }.compact

        messages.push obj
      end
    end
  end
end
