# frozen_string_literal: true

class Community < ApplicationRecord
  include Accessible
  include Attachable
  include HasSchemaDefinition
  include HasSystemSlug
  include HierarchicalEntity

  has_many :collections, dependent: :destroy

  has_many :community_memberships, dependent: :destroy, inverse_of: :community

  has_many :users, through: :community_memberships

  alias_attribute :name, :title

  def hierarchical_parent
    nil
  end

  alias contextual_parent hierarchical_parent
end
