# frozen_string_literal: true

class CommunityMembership < ApplicationRecord
  belongs_to :community, inverse_of: :community_memberships
  belongs_to :role, optional: true, inverse_of: :community_memberships
  belongs_to :user, inverse_of: :community_memberships
end
