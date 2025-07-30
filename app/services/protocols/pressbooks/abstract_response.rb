# frozen_string_literal: true

module Protocols
  module Pressbooks
    class AbstractResponse
      extend ActiveModel::Callbacks
      extend Dry::Core::ClassAttributes
      extend Dry::Initializer

      defines :paginated, type: Types::Bool

      defines :request_klass, type: Types::Class

      paginated false

      request_klass self

      option :client, Protocols::Types.Instance(Protocols::Pressbooks::Client)

      option :request, Protocols::Types.Instance(Protocols::Pressbooks::AbstractRequest)

      option :raw_response, Protocols::Types.Instance(::Faraday::Response)

      define_model_callbacks :initialize, only: %i[before after]

      attr_reader :parsed_body

      def initialize(...)
        @parsed_body = nil

        run_callbacks :initialize do
          super

          @parsed_body = parse_body
        end
      end

      private

      # @return [Hash]
      def parse_body
        raw_response.body
      end

      class << self
        # @param [Class(Protocols::Pressbooks::AbstractRequest)] klass
        # @return [void]
        def requests_with!(klass)
          request_klass klass
        end
      end
    end
  end
end
