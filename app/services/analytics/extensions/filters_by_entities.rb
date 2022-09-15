# frozen_string_literal: true

module Analytics
  module Extensions
    class FiltersByEntities < GraphQL::Schema::FieldExtension
      def apply
        field.argument :entity_ids, [GraphQL::Types::ID, { null: false }], loads: ::Types::AnyEntityType, default_value: [], required: false do
          description <<~TEXT
          Optionally filter by specific entities.
          TEXT
        end
      end
    end
  end
end
