# frozen_string_literal: true

module TestHelpers
  module GrantsAccess
    module ExampleHelpers
      def grant_access!(role, on:, to:)
        Access::Grant.new.call(role, on: on, to: to)
      end
    end
  end
end

RSpec.configure do |config|
  config.include TestHelpers::GrantsAccess::ExampleHelpers, type: :policy
  config.include TestHelpers::GrantsAccess::ExampleHelpers, grants_access: true
end
