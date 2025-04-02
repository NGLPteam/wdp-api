# frozen_string_literal: true

module Users
  module EmailActions
    # @see Users::EmailActions::UpdatePassword
    class UpdatePasswordAction < Users::EmailActions::AbstractAction
      actions %w[UPDATE_PASSWORD].freeze
    end
  end
end
