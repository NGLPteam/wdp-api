# frozen_string_literal: true

module Types
  class EntityBreadcrumbType < Types::BaseObject
    implements GraphQL::Types::Relay::Node

    global_id_field :id

    field :crumb, Types::AnyEntityType, null: false
    field :depth, Int, null: false
    field :label, String, null: false
    field :kind,  Types::EntityKindType, null: false
    field :slug,  String, null: false

    def crumb
      Support::Loaders::AssociationLoader.for(EntityBreadcrumb, :crumb).load(object)
    end

    def label
      crumb.then do |crumb|
        crumb.breadcrumb_label
      end
    end

    def kind
      object.crumb_type
    end

    def slug
      object.system_slug
    end
  end
end
