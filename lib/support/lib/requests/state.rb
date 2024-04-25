# frozen_string_literal: true

module Support
  module Requests
    # A state object that wraps GraphQL requests and provides certain caching
    # and other support in the context.
    class State
      extend ActiveModel::Callbacks

      define_model_callbacks :request, :connection

      def initialize
        @lookups = Concurrent::Map.new
      end

      # @yieldreturn [void]
      # @return [void]
      def wrap
        run_callbacks :request do
          yield
        end
      end
    end
  end
end
