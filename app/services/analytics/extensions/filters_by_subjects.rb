# frozen_string_literal: true

module Analytics
  module Extensions
    class FiltersBySubjects < GraphQL::Schema::FieldExtension
      def apply
        field.argument :subject_ids, [GraphQL::Types::ID, { null: false }], loads: ::Types::AnyAnalyticsSubjectType, default_value: [], required: false do
          description <<~TEXT
          Optionally filter by specific subjects.

          Presently this is just assets, but it may expand in the future.
          TEXT
        end
      end
    end
  end
end
