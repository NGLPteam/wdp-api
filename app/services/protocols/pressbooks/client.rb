# frozen_string_literal: true

module Protocols
  module Pressbooks
    class Client
      include Dry::Initializer[undefined: false].define -> do
        option :http, Protocols::Types.Instance(::Faraday::Connection)

        option :base_url, Protocols::Types::URL

        option :allow_insecure, Protocols::Types::Bool, default: proc { false }
      end

      # @return [Protocols::Pressbooks::Check::Response]
      def check
        make_request!(Protocols::Pressbooks::Check::Request)
      end

      # @param [Integer] current_page
      # @return [Protocols::Pressbooks::Books::Response]
      def fetch_books(**options)
        make_request!(Protocols::Pressbooks::Books::Request, **options)
      end

      private

      def make_request!(klass, **options)
        options[:client] = self

        klass.new(**options).()
      end
    end
  end
end
