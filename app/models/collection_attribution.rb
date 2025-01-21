# frozen_string_literal: true

class CollectionAttribution < ApplicationRecord
  include Attribution
  include HasEphemeralSystemSlug
  include TimestampScopes

  ATTRIBUTED_TUPLE = %i[collection_id contributor_id].freeze

  belongs_to :collection, inverse_of: :attributions
  belongs_to :contributor, inverse_of: :collection_attributions

  has_many_readonly :contributions,
    class_name: "CollectionContribution",
    primary_key: ATTRIBUTED_TUPLE,
    foreign_key: ATTRIBUTED_TUPLE

  has_many :roles, -> { in_default_order }, through: :contributions, source: :role
end
