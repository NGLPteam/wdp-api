# frozen_string_literal: true

module Testing
  module Keycloak
    class GlobalRegistry
      extend ActiveModel::Callbacks

      include Singleton

      def initialize
        @users = Testing::Keycloak::UserRegistry.new(global: self)
      end

      # @return [void]
      def reset!
        users.reset!
      end

      # @return [Testing::Keycloak::UserRegistry]
      attr_reader :users

      class << self
        delegate_missing_to :instance
      end
    end
  end
end
