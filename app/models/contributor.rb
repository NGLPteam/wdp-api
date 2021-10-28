# frozen_string_literal: true

class Contributor < ApplicationRecord
  include ImageUploader::Attachment.new(:image)
  include SchematicReferent
  include ScopesForIdentifier

  pg_enum! :kind, as: "contributor_kind"

  attribute :links, Contributors::Link.to_array_type
  attribute :properties, Contributors::Properties.to_type

  has_many :harvest_contributors, inverse_of: :contributor, dependent: :nullify

  has_many :collection_contributions, dependent: :destroy, inverse_of: :contributor
  has_many :collections, through: :collection_contributions

  has_many :item_contributions, dependent: :destroy, inverse_of: :contributor
  has_many :items, through: :item_contributions

  scope :by_kind, ->(kind) { where(kind: kind) }

  validates :identifier, :kind, presence: true
  validates :identifier, uniqueness: true

  validates :properties, store_model: true

  delegate :display_name, to: :properties

  def fetch_property(property_name, from: nil)
    property_source(from)&.public_send(property_name)
  end

  def graphql_node_type
    organization? ? Types::OrganizationContributorType : Types::PersonContributorType
  end

  def property_source(from)
    case from
    when /organization/
      properties&.organization
    when /person/
      properties&.person
    else
      self
    end
  end

  def system_slug
    call_operation("slugs.encode_id", id).value_or(nil)
  end

  def to_schematic_referent_label
    display_name
  end

  class << self
    def by_given_and_family_name(given_name, family_name)
      person.where(arel_json_contains(:properties, person: { given_name: given_name, family_name: family_name }))
    end

    def by_organization_name(name)
      organization.where(arel_json_contains(:properties, organization: { legal_name: name }))
    end
  end
end
