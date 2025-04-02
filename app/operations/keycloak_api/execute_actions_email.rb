# frozen_string_literal: true

module KeycloakAPI
  # @see KeycloakAPI::EmailActionsExecutor
  class ExecuteActionsEmail < Support::SimpleServiceOperation
    service_klass KeycloakAPI::EmailActionsExecutor
  end
end
