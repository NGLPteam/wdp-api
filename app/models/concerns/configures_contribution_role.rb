# frozen_string_literal: true

module ConfiguresContributionRole
  extend ActiveSupport::Concern

  included do
    has_one :contribution_role_configuration, as: :source, inverse_of: :source, autosave: true, dependent: :destroy
  end
end
