# frozen_string_literal: true

module Harvesting
  module Logs
    # @abstract
    # A null-type logger that will catch all messages not otherwise caught
    # during the harvesting process.
    class Null
      include Redis::Objects

      redis_id_field :null_id

      list :messages, marshal: true, maxlength: 1000,
        expireat: proc { 1.day.from_now }

      def blank?
        true
      end

      def null_id
        ?0
      end

      def log(message, tags: [], level: nil)
        obj = { message:, time: Time.current, tags: tags.presence, level: }.compact

        messages.push obj
      end
    end
  end
end
