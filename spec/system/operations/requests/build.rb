# frozen_string_literal: true

module Testing
  module Requests
    class Build
      include TestingAPI::Deps[:gql]

      # @return [Testing::GQL::RequestTester]
      def call
        set_up!

        yield self if block_given?

        expectation = @effects.reduce(&:and) if @effects.any?

        attrs = {
          data: @data,
          expectation:,
          effects: @effects.presence,
          top_level_errors: @top_level_errors,
        }

        Testing::GQL::RequestTester.new attrs
      ensure
        set_up!
      end

      # @!group DSL Methods

      def effect!(matcher)
        @effects << matcher
      end

      def data!(value)
        @data = value
      end

      def top_level_errors!(value)
        @top_level_errors = value
      end

      alias errors! top_level_errors!

      def unauthorized!
        top_level_errors! @gql.top_level_unauthorized
      end

      # @!endgroup

      private

      # @return [void]
      def set_up!
        @effects = []

        @data = nil

        @top_level_errors = nil
      end
    end
  end
end
