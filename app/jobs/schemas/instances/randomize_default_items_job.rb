# frozen_string_literal: true

module Schemas
  module Instances
    class RandomizeDefaultItemsJob < ApplicationJob
      include JobIteration::Iteration

      unique :until_and_while_executing, lock_ttl: 1.hour, on_conflict: :log

      queue_as :maintenance

      # @param [String] cursor
      # @return [void]
      def build_enumerator(cursor:)
        enumerator_builder.active_record_on_records(
          Item.filtered_by_schema_version("default:item"),
          cursor: cursor
        )
      end

      def each_iteration(item)
        slug = schema_version_slugs.sample

        Schemas::Instances::AlterAndGenerateJob.perform_later item, slug
      end

      def schema_version_slugs
        @schema_version_slugs ||= SchemaDefinition.non_default.item.pluck(:system_slug).map do |slug|
          "#{slug}:latest"
        end
      end
    end
  end
end
