# frozen_string_literal: true

module Protocols
  module Pressbooks
    class ResumptionToken < Support::FlexibleStruct
      attribute :current_page, Protocols::Types::Integer

      def to_cursor
        Base64.urlsafe_encode64(to_json)
      end

      class << self
        # @param [String] cursor
        # @return [Hash]
        def parse(cursor)
          decoded = Base64.urlsafe_decode64(cursor)

          data = Oj.load(decoded)

          new(data).to_h
        rescue ArgumentError, Oj::Error, Dry::Struct::Error => e
          raise Protocols::Pressbooks::InvalidResumptionTokenError, "Invalid cursor: #{e.message}"
        end
      end
    end
  end
end
