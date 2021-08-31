# frozen_string_literal: true

class Contributor < ApplicationRecord
  include ImageUploader::Attachment.new(:image)

  pg_enum! :kind, as: "contributor_kind"

  attribute :links, Contributors::Link.to_array_type
  attribute :properties, Contributors::Properties.to_type

  has_many :collection_contributions, dependent: :destroy, inverse_of: :contributor
  has_many :collections, through: :collection_contributions

  has_many :item_contributions, dependent: :destroy, inverse_of: :contributor
  has_many :items, through: :item_contributions

  scope :by_kind, ->(kind) { where(kind: kind) }

  validates :identifier, :kind, presence: true

  validates :properties, store_model: true

  def graphql_node_type
    organization? ? Types::OrganizationContributorType : Types::PersonContributorType
  end

  def system_slug
    call_operation("slugs.encode_id", id).value_or(nil)
  end
end
