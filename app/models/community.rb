# frozen_string_literal: true

class Community < ApplicationRecord
  include HasSystemSlug

  has_many :collections, dependent: :destroy

  has_many :community_memberships, dependent: :destroy, inverse_of: :community

  has_many :users, through: :community_memberships
end
