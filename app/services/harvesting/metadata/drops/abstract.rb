# frozen_string_literal: true

module Harvesting
  module Metadata
    # @abstract
    module Drops
      class Abstract < Liquid::Drop
        extend ActiveModel::Callbacks
        extend Dry::Core::ClassAttributes

        include Dry::Core::Constants

        define_model_callbacks :initialize, only: %i[after]

        def initialize(*args, metadata_context:, **kwargs)
          super()

          @metadata_context = metadata_context

          run_callbacks :initialize do
            set_up!(*args, **kwargs)
          end
        end

        protected

        # @return [Harvesting::Metadata::Context]
        attr_accessor :metadata_context

        private

        # @abstract
        # @return [void]
        def set_up!(...); end

        def subdrop(drop_klass, *args, **kwargs)
          return if args.length == 1 && args[0].nil?

          kwargs[:metadata_context] = metadata_context

          drop_klass.new(*args, **kwargs)
        end
      end
    end
  end
end
