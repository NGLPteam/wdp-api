# frozen_string_literal: true

# A composite of {CollectoinAttribution} and {ItemAttribution},
# intended for use when querying attributions from the perspective
# of a {Contributor}.
class ContributorAttribution < ApplicationRecord
  include HasEphemeralSystemSlug
  include MaterializedView
  include TimestampScopes

  self.primary_key = :attribution_id

  ATTRIBUTED_COLLECTION_TUPLE = %i[collection_id contributor_id].freeze
  ATTRIBUTED_ITEM_TUPLE = %i[item_id contributor_id].freeze

  pg_enum! :kind, as: "child_entity_kind", prefix: :for

  belongs_to_readonly :collection, optional: true
  belongs_to_readonly :entity, polymorphic: true
  belongs_to_readonly :item, optional: true
  belongs_to_readonly :contributor, inverse_of: :contributor_attributions

  has_many_readonly :collection_contributions,
    primary_key: ATTRIBUTED_COLLECTION_TUPLE,
    foreign_key: ATTRIBUTED_COLLECTION_TUPLE

  has_many :collection_roles, -> { in_default_order }, through: :collection_contributions, source: :role

  has_many_readonly :item_contributions,
    primary_key: ATTRIBUTED_ITEM_TUPLE,
    foreign_key: ATTRIBUTED_ITEM_TUPLE

  has_many :item_roles, -> { in_default_order }, through: :item_contributions, source: :role

  scope :in_default_order, -> { lazily_order(:title) }

  # @Return [Class]
  def graphql_node_type
    if for_collection?
      ::Types::ContributorCollectionAttributionType
    else
      ::Types::ContributorItemAttributionType
    end
  end

  class << self
    def graphql_connection_type
      ::Types::ContributorAttributionConnectionType
    end

    def graphql_edge_type
      ::Types::ContributorAttributionEdgeType
    end

    def published_order_column
      :published_rank
    end

    def title_order_column
      :title_rank
    end
  end
end
