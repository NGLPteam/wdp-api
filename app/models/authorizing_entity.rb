# frozen_string_literal: true

# This is a flattened, denormalized table that is used for very fast permission validation.
#
# It is created by an {Entity} after commit and not managed directly.
#
# @see Entities::CalculateAuthorizing
class AuthorizingEntity < ApplicationRecord
  self.primary_key = %i[auth_path entity_id scope hierarchical_type hierarchical_id].freeze
end
