# frozen_string_literal: true

class EntityAncestor < ApplicationRecord
  belongs_to :entity, polymorphic: true
  belongs_to :ancestor, polymorphic: true

  scope :by_name, ->(name) { where(name: name) }
  scope :in_default_order, -> { order(relative_depth: :asc, name: :asc) }

  class << self
    def graphql_node_type
      Types::NamedAncestorType
    end
  end
end
