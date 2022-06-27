# frozen_string_literal: true

class Contributor < ApplicationRecord
  include HasEphemeralSystemSlug
  include HasUniqueORCID
  include ImageUploader::Attachment.new(:image)
  include SchematicReferent
  include ScopesForIdentifier

  strip_attributes only: %i[email orcid url]

  pg_enum! :kind, as: "contributor_kind"

  attribute :links, Contributors::Link.to_array_type
  attribute :properties, Contributors::Properties.to_type

  has_many :harvest_contributors, inverse_of: :contributor, dependent: :nullify

  has_many :collection_contributions, dependent: :destroy, inverse_of: :contributor
  has_many :collections, through: :collection_contributions

  has_many :item_contributions, dependent: :destroy, inverse_of: :contributor
  has_many :items, through: :item_contributions

  scope :by_kind, ->(kind) { where(kind: kind) }
  scope :unharvested, -> { where.not(id: HarvestContributor.harvested_ids) }

  validates :identifier, :kind, presence: true
  validates :identifier, uniqueness: true
  validates :orcid, orcid: { allow_blank: true }

  validates :properties, store_model: true

  delegate :display_name, to: :properties

  # @param [Contributable] contributable
  # @return [Dry::Monads::Result]
  def attach!(contributable)
    call_operation("contributors.attach", self, contributable)
  end

  # @api private
  # @return [void]
  def count_collection_contributions!
    call_operation "contributors.count_collections", self
  end

  # @api private
  # @return [void]
  def count_item_contributions!
    call_operation "contributors.count_items", self
  end

  # @return [String]
  def display_kind
    return "Contributor" unless kind?

    kind.to_s.titleize
  end

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

  # @api private
  # @return [void]
  def recount_contributions!
    call_operation "contributors.recount_contributions", self
  end

  # @return [String]
  def safe_name
    name.presence || "(Unknown #{display_kind})"
  end

  def to_schematic_referent_label
    display_name
  end

  class << self
    # @param [String] input
    # @return [ActiveRecord::Relation]
    def apply_prefix(input)
      needle = WDPAPI::Container["searching.prefix_sanitize"].(input)

      return all if needle.blank?

      where_begins_like(
        search_name: needle,
        _case_sensitive: true
      )
    end

    def by_given_and_family_name(given_name, family_name)
      person.where(arel_json_contains(:properties, person: { given_name: given_name, family_name: family_name }))
    end

    def by_organization_name(name)
      organization.where(arel_json_contains(:properties, organization: { legal_name: name }))
    end
  end
end
