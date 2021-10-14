# frozen_string_literal: true

class ContextuallyAssignedAccessGrant < ApplicationRecord
  self.primary_key = %i[user_id hierarchical_type hierarchical_id access_grant_id]

  CONTEXT_KEY = %i[user_id hierarchical_type hierarchical_id].freeze

  belongs_to :contextual_permission,
    primary_key: CONTEXT_KEY,
    foreign_key: CONTEXT_KEY,
    inverse_of: :contextually_assigned_access_grants

  belongs_to :access_grant, inverse_of: :contextually_assigned_access_grants
end
