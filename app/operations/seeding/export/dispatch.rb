# frozen_string_literal: true

module Seeding
  module Export
    class Dispatch
      include Dry::Effects::Handler.Interrupt(:skip, as: :catch_skip)
      include MeruAPI::Deps[
        export_entity: "seeding.export.export_entity",
        export_page: "seeding.export.export_page",
        export_relation: "seeding.export.export_relation",
      ]

      # @param [Object] input
      # @return [Jbuilder, nil]
      def call(input)
        skipped, result = catch_skip do
          handle input
        end

        return result unless skipped
      end

      private

      def handle(input)
        case input
        when ::HierarchicalEntity
          export_entity.(input)
        when ::Page
          export_page.(input)
        when ActiveRecord::Relation, Support::Models::Types::ModelList
          export_relation.(input)
        end
      end
    end
  end
end
