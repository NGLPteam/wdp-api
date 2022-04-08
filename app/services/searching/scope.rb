# frozen_string_literal: true

module Searching
  # The scope serves as the root for where we "begin" a search
  class Scope
    include Dry::Core::Memoizable
    include Dry::Initializer[undefined: false].define -> do
      option :user, Users::Types::Current, default: Users::Types::DEFAULT
      option :origin, Searching::Types::Origin, default: proc { :global }
      option :visibility, Entities::Types::Visibility, default: proc { :visible }

      option :auth_state, Users::Types::State, default: proc { user }
    end

    include Shared::Typing

    delegate :entity?, :global?, :schema?, prefix: :from, to: :origin
    delegate :type, to: :origin, prefix: true

    # @return [<SchemaVersion>]
    memoize def available_schema_versions
      SchemaVersion.where(id: base_relation.distinct.select(:schema_version_id)).in_default_order.all
    end

    # @return [ActiveRecord::Relation<Entity>]
    def base_relation
      filter_by_visibility origin.relation
    end

    private

    # @see Entities::VisibilityRestrictor
    # @return [ActiveRecord::Relation<Entity>]
    def filter_by_visibility(relation)
      Entities::VisibilityRestrictor.new(user: user, visibility: visibility, relation: relation).call
    end
  end
end
