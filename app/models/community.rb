# frozen_string_literal: true

class Community < ApplicationRecord
  include Accessible
  include Attachable
  include AutoIdentifier
  include GloballyUniqueIdentifier
  include HasHeroImageLayout
  include HasSchemaDefinition
  include HasSystemSlug
  include HarvestTarget
  include HierarchicalEntity
  include ImageUploader::Attachment.new(:logo)
  include ScopesForIdentifier

  drop_klass Templates::Drops::CommunityDrop

  acts_as_list add_new_at: :bottom

  has_many :collections, dependent: :destroy

  has_many :items, through: :collections

  has_many :community_memberships, dependent: :destroy, inverse_of: :community

  has_many :users, through: :community_memberships

  validates :title, presence: true

  alias_attribute :name, :title

  after_create :grant_system_roles!

  # @return [Community]
  def community
    self
  end

  def hierarchical_parent
    nil
  end

  alias contextual_parent hierarchical_parent

  # @api private
  # @see Communities::GrantSystemRoles
  # @return [void]
  def grant_system_roles!
    call_operation("communities.grant_system_roles", self).value!
  end
end
