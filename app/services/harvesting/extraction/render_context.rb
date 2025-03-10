# frozen_string_literal: true

module Harvesting
  module Extraction
    # A context object that generates assigns and similar data for a {HarvestRecord}.
    class RenderContext
      include Dry::Initializer[undefined: false].define -> do
        param :harvest_record, ::Harvesting::Types::Record

        option :metadata_context, Types.Instance(::Harvesting::Metadata::Context), default: proc { harvest_record.build_metadata_context }
        option :extraction_context, Types.Instance(::Harvesting::Extraction::Context), default: proc { harvest_record.build_extraction_context }
      end

      delegate :mapping, to: :extraction_context

      # @return [{ String => Object }]
      attr_reader :assigns

      # @return [Harvesting::Extraction::Contributions::Config]
      attr_reader :contributions

      def initialize(...)
        super

        compile_assigns!

        configure_contributions!
      end

      # @return [<Harvesting::Entities::Struct>]
      def render_entity_structs
        mapping.entity_mapping.render_structs_for self
      end

      private

      # @return [void]
      def compile_assigns!
        @assigns = metadata_context.assigns.with_indifferent_access

        compile_shared_assigns!

        @assigns = @assigns.stringify_keys.freeze
      end

      # @return [void]
      def compile_shared_assigns!
        mapping.each_shared_assignment do |assignment|
          @assigns[assignment.name] ||= assignment.value_for(self)
        end
      end

      # @return [void]
      def configure_contributions!
        @contributions = mapping.to_contributions_config
      end
    end
  end
end
