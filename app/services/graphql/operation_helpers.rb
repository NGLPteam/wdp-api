# frozen_string_literal: true

module Graphql
  module OperationHelpers
    def app_container
      WDPAPI::Container
    end

    def resolve_container_value(*args)
      app_container.resolve(*args)
    end

    def perform_operation(name, *args, &block)
      operation = resolve_container_value name

      result = operation.call(*args)

      return result unless block_given?

      Dry::Matcher::ResultMatcher.call(result, &block)
    end
  end
end
