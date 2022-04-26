# frozen_string_literal: true

module Seeding
  module Export
    # Export {HierarchicalEntity an entity}.
    #
    # @see Seeding::Export::CommunityExporter
    # @see Seeding::Export::CollectionExporter
    class ExportEntity
      include Dry::Effects.Interrupt(:skip)

      # @param [Community, Collection] entity
      # @return [Hash, nil]
      def call(entity)
        return skip unless Seeding::Brokerage.supported? entity

        exporter_for(entity).call
      end

      private

      def exporter_for(entity)
        case entity
        when ::Community then Seeding::Export::CommunityExporter.new(entity)
        when ::Collection then Seeding::Export::CollectionExporter.new(entity)
        else
          # :nocov:
          raise TypeError, "can't export #{entity.class.name}"
          # :nocov:
        end
      end
    end
  end
end
