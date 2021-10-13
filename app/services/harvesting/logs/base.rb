# frozen_string_literal: true

module Harvesting
  module Logs
    class Base
      extend Dry::Initializer

      include Redis::Objects

      param :model, AppTypes::Model

      delegate :id, to: :model, prefix: true

      redis_id_field :model_id

      list :messages, marshal: true, maxlength: 1000

      def log(message, tags: [], level: nil)
        obj = { message: message, time: Time.current, tags: tags.presence, level: level }.compact

        messages.push obj
      end
    end
  end
end
