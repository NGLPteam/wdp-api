# frozen_string_literal: true

module Types
  # Exposes a `breadcrumbs` property for any type that implements this.
  module HasEntityBreadcrumbs
    include Types::BaseInterface

    field :breadcrumbs, [Types::EntityBreadcrumbType, { null: false }], null: false do
      description "Previous entries in the hierarchy"
    end

    # @see HierarchicalEntity#entity_breadcrumbs
    # @see Support::Loaders::AssociationLoader
    # @return [<EntityBreadcrumb>]
    def breadcrumbs
      Support::Loaders::AssociationLoader.for(object.class, :entity_breadcrumbs).load(object)
    end
  end
end
