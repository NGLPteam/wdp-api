# frozen_string_literal: true

module Protocols
  module Pressbooks
    class AbstractRequest
      extend ActiveModel::Callbacks
      extend Dry::Core::ClassAttributes
      extend Dry::Initializer

      defines :mapped_query_params, type: Types::Hash.map(Types::Symbol, Types::Any)

      defines :paginated, type: Types::Bool

      defines :response_klass, type: Types::Class

      defines :suffix, type: Types::String

      mapped_query_params Dry::Core::Constants::EMPTY_HASH

      paginated false

      response_klass Protocols::Pressbooks::AbstractResponse

      suffix ?/

      option :client, Protocols::Types.Instance(Protocols::Pressbooks::Client)

      option :base_url, Protocols::Types::URL, default: proc { client.base_url }

      define_model_callbacks :initialize, only: %i[before after]
      define_model_callbacks :query_params
      define_model_callbacks :request

      # @return [{ String => #to_s }]
      attr_reader :query_params

      attr_reader :response

      # @return [URI]
      attr_reader :uri

      def initialize(...)
        @query_params = {}.with_indifferent_access

        @uri = nil

        run_callbacks :initialize do
          super

          run_callbacks :query_params do
            assign_query_params!
          end

          query_params.freeze

          @uri = build_uri
        end
      end

      # @return [Protocols::Pressbooks::AbstractResponse]
      def call
        make_request
      end

      # @api private
      # @return [Hash]
      def current_options
        self.class.dry_initializer.attributes(self)
      end

      # @!attribute [r] suffix
      # @return [String]
      def suffix
        self.class.suffix
      end

      private

      def assign_query_param!(key, value)
        query_params[key.to_s] = normalize_query_param(value)
      end

      # @return [void]
      def assign_query_params!
        self.class.mapped_query_params.each do |key, value|
          assign_query_param! key, value
        end
      end

      def build_uri
        uri = ::URI.join(base_url, suffix)

        uri.query = URI.encode_www_form query_params

        @uri = uri.freeze
      end

      def normalize_query_param(value)
        case value
        when Symbol
          __send__(value)
        else
          value
        end
      end

      # @return [Protocols::Pressbooks::AbstractResponse]
      def make_request
        return @response if @response.present?

        run_callbacks :request do
          raw_response = client.http.get(uri)

          @response = self.class.response_klass.new(client:, request: self, raw_response:)
        end
      end

      class << self
        # @param [#to_sym] key
        # @param [Symbol, Object, Proc] value
        # @return [void]
        def map_query_param!(key, value)
          mapping = mapped_query_params.dup

          mapping[key.to_sym] = value

          mapped_query_params mapping.freeze
        end

        # @param [Class(Protocols::Pressbooks::AbstractResponse)] klass
        # @return [void]
        def responds_with!(klass)
          response_klass klass

          klass.requests_with!(klass)
        end
      end
    end
  end
end
