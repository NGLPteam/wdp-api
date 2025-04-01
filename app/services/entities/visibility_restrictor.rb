# frozen_string_literal: true

module Entities
  # Given a user and a visibility option, selectively filter a scope of records
  # based on what's actually available.
  #
  # For anonymous users, it ignores the `visibility` option entirely and only returns
  # entities that are currently visible.
  class VisibilityRestrictor
    include Dry::Initializer[undefined: false].define -> do
      option :user, Users::Types::Current, default: Users::Types::DEFAULT
      option :visibility, Entities::Types::VisibilityFilter, default: proc { :visible }
      option :relation, Entities::Types::VisibilityRelation, default: proc { ::Entity.all }
    end

    delegate :anonymous?, to: :user

    # @return [ActiveRecord::Relation<Entity>]
    def call
      return relation.currently_visible if anonymous?

      case visibility
      when :visible then relation.currently_visible
      when :hidden then relation.currently_hidden
      else
        relation.all
      end
    end
  end
end
