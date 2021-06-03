# frozen_string_literal: true

class AccessGrant < ApplicationRecord
  include ScopesForUser

  belongs_to :accessible, polymorphic: true
  belongs_to :role, inverse_of: :access_grants
  belongs_to :user, inverse_of: :access_grants

  belongs_to :community, optional: true
  belongs_to :collection, optional: true
  belongs_to :item, optional: true

  before_validation :sync_accessible!

  # @!private
  # @return [void]
  def sync_accessible!
    self.auth_path = accessible.try(:auth_path)
    self.auth_query = auth_path? ? "#{auth_path}.*" : nil

    case accessible
    when Community
      self.community = accessible
      self.collection = nil
      self.item = nil
    when Collection
      self.community = nil
      self.collection = accessible
      self.item = nil
    when Item
      self.community = nil
      self.collection = nil
      self.item = accessible
    else
      errors.add :accessible, "not a supported accessible model"
    end
  end

  class << self
    def has_granted?(role, on:, to:)
      exists?(role: role, accessible: on, user: to)
    end

    def fetch(accessible, user)
      where(accessible: accessible, user: user).first_or_initialize
    end
  end
end
