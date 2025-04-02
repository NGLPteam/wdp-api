# frozen_string_literal: true

module Users
  module EmailActions
    # @see Users::EmailActions::UpdatePasswordAction
    class UpdatePassword < Support::SimpleServiceOperation
      service_klass Users::EmailActions::UpdatePasswordAction
    end
  end
end
