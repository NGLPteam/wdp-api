# frozen_string_literal: true

module Metadata
  module Shared
    # @abstract
    class AbstractDrop < Liquid::Drop
      extend ActiveModel::Callbacks
      extend Dry::Core::ClassAttributes

      include Dry::Core::Memoizable
      include Dry::Effects::Handler.Reader(:parent_metadata_context)
      include Dry::Effects.Reader(:parent_metadata_context, default: nil)

      define_model_callbacks :initialize, only: %i[after]
      define_model_callbacks :child_drop

      defines :mapper_class, type: Metadata::Types::Class

      mapper_class Metadata::Shared::AbstractMapper

      around_child_drop :provide_metadata_context!

      def initialize(data, metadata_context: nil)
        super()

        @data = data

        run_callbacks :initialize do
          @metadata_context = metadata_context || parent_metadata_context
        end
      end

      private

      # @param [Symbol] accessor_name
      # @return [Liquid::Drop, Object, nil]
      def build_child_drop_for(accessor_name)
        run_callbacks :child_drop do
          value = @data.public_send(accessor_name)

          if value.is_a?(Array)
            value.map(&:to_liquid)
          else
            value.to_liquid
          end
        end
      end

      # @return [::Harvesting::Metadata::Context, nil]
      attr_reader :metadata_context

      # @return [void]
      def provide_metadata_context!
        with_parent_metadata_context metadata_context do
          yield
        end
      end
    end
  end
end
