# frozen_string_literal: true

module Types
  # @abstract
  class AbstractModel < Types::BaseObject
    implements GraphQL::Types::Relay::Node
    implements Types::Sluggable

    global_id_field :id

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    class << self
      def inherited(subclass)
        super if defined?(super)

        subclass.global_id_field :id
      end
    end
  end
end
