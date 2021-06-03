# frozen_string_literal: true

class Role < ApplicationRecord
  include HasSystemSlug

  has_many :access_grants, dependent: :destroy, inverse_of: :role

  has_many :community_memberships, dependent: :destroy, inverse_of: :role

  attribute :access_control_list, Roles::AccessControlList.to_type

  before_validation :calculate_allowed_actions!

  validates :name, presence: true, uniqueness: true

  # @!private
  # @return [void]
  def calculate_allowed_actions!
    self.allowed_actions = access_control_list.calculate_allowed_actions
  end

  class << self
    def fetch(name)
      where(name: name).first!
    end
  end
end
