# frozen_string_literal: true

class ContextuallyAssignedRole < ApplicationRecord
  self.primary_key = %i[user_id hierarchical_type hierarchical_id role_id]

  CONTEXT_KEY = %i[user_id hierarchical_type hierarchical_id].freeze

  belongs_to :contextual_permission,
    primary_key: CONTEXT_KEY,
    foreign_key: CONTEXT_KEY,
    inverse_of: :contextually_assigned_roles

  belongs_to :role, inverse_of: :contextually_assigned_roles
end