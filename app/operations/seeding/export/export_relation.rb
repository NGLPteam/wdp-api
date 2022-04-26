# frozen_string_literal: true

module Seeding
  module Export
    class ExportRelation
      # @param [ActiveRecord::Relation, <ApplicationRecord>] relation
      # @return [Jbuilder]
      def call(relation)
        Seeding::Export::RelationExporter.new(relation).call
      end
    end
  end
end
