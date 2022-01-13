# frozen_string_literal: true

# A named, derived ancestor for a specific {Entity}, based on the defined
# ancestors in its {SchemaVersion}.
#
# @see SchemaVersionAncestor
class EntityAncestor < ApplicationRecord
  include View

  self.primary_key = %i[entity_type entity_id name].freeze

  belongs_to :entity, polymorphic: true
  belongs_to :ancestor, polymorphic: true

  scope :by_name, ->(name) { where(name: name) }
  scope :in_default_order, -> { order(relative_depth: :asc, name: :asc) }

  class << self
    # @see Types::NamedAncestorType
    def graphql_node_type
      Types::NamedAncestorType
    end
  end
end
