# frozen_string_literal: true

module Entities
  # Types related to managing and synchronizing an {Entity}.
  module Types
    include Dry.Types

    extend Shared::EnhancedTypes

    # A pattern for matching an auth_path, composed of multiple slugs
    AUTH_PATH_FORMAT = /\A[a-z0-9]+(?:(?:\.[a-z0-9]+)|(?<!\._)\._(?!\z))*\z/i.freeze

    HIERARCHICAL_TYPES = %w[Community Collection Item].freeze

    ENTITY_SCOPES = %w[communities collections items].freeze

    ENTITY_TYPES = [*HIERARCHICAL_TYPES, "EntityLink"].freeze

    SLUG_FORMAT = /\A[a-z0-9]+\z/i.freeze

    AuthPath = String.constrained(format: AUTH_PATH_FORMAT)

    Entity = Instance(::HierarchicalEntity)

    EntityScope = Coercible::String.enum(*ENTITY_SCOPES)

    EntityType = String.enum(*ENTITY_TYPES)

    HierarchicalType = String.enum(*HIERARCHICAL_TYPES)

    Scope = EntityScope | ::Links::Types::Scope

    Slug = String.constrained(format: SLUG_FORMAT)

    # @see ::Types::EntityVisibilityFilterType
    Visibility = Symbol.enum(:all, :visible, :hidden).fallback(:visible)

    # A type matching an ActiveRecord::Relation scope that {ReferencesEntityVisibility}.
    #
    # At minimum, it must respond to the mentioned scopes
    VisibilityRelation = Interface(:all, :currently_visible, :currently_hidden)
  end
end
