# frozen_string_literal: true

class ContextuallyAssignedRole < ApplicationRecord
  self.primary_key = %i[user_id hierarchical_type hierarchical_id role_id]

  belongs_to :contextual_permission, primary_key: %i[user_id hierarchical_type hierarchical_id],
    foreign_key: %i[user_id hierarchical_type hierarchical_id],
    inverse_of: :contextually_assigned_roles

  belongs_to :role, inverse_of: :contextually_assigned_roles
end
