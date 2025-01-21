# frozen_string_literal: true

class ItemAttribution < ApplicationRecord
  include Attribution
  include HasEphemeralSystemSlug
  include TimestampScopes

  ATTRIBUTED_TUPLE = %i[item_id contributor_id].freeze

  belongs_to :item, inverse_of: :attributions
  belongs_to :contributor, inverse_of: :item_attributions

  has_many_readonly :contributions,
    class_name: "ItemContribution",
    primary_key: ATTRIBUTED_TUPLE,
    foreign_key: ATTRIBUTED_TUPLE

  has_many :roles, -> { in_default_order }, through: :contributions, source: :role
end
