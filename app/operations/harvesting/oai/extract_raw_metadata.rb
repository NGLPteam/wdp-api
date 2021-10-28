# frozen_string_literal: true

module Harvesting
  module OAI
    class ExtractRawMetadata
      include Dry::Monads[:result]

      # @param [OAI::Record] oai_record
      # @return [String]
      def call(oai_record)
        metadata = oai_record.metadata

        return Success(nil) if metadata.nil?

        if metadata.elements.size == 1
          Success metadata.elements.first.to_s
        elsif metadata.children.any?
          compress_children_for metadata
        else
          Failure[:invalid_metadata, "expected metadata to have at least 1 child"]
        end
      end

      private

      def compress_children_for(metadata)
        Success metadata.children.map(&:to_s).join.strip
      end
    end
  end
end
