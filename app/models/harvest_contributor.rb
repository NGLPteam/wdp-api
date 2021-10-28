# frozen_string_literal: true

# A staging ground to a {Contributor} from a {HarvestSource}.
class HarvestContributor < ApplicationRecord
  include ScopesForIdentifier

  pg_enum! :kind, as: "contributor_kind"

  attribute :links, Contributors::Link.to_array_type
  attribute :properties, Contributors::Properties.to_type

  belongs_to :harvest_source, inverse_of: :harvest_contributors
  belongs_to :contributor, optional: true

  has_many :harvest_contributions, inverse_of: :harvest_contributor, dependent: :destroy

  validates :properties, store_model: true

  validates :identifier, :kind, presence: true
  validates :identifier, uniqueness: { scope: :harvest_source_id }

  delegate :display_name, to: :properties
end
