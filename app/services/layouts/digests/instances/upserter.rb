# frozen_string_literal: true

module Layouts
  module Digests
    module Instances
      # @see Layouts::Digests::Instances::Upsert
      class Upserter < Support::HookBased::Actor
        include Dry::Initializer[undefined: false].define -> do
          param :layout_instance, ::Layouts::Types::LayoutInstance
        end

        UNIQUE_BY = %i[layout_instance_type layout_instance_id].freeze

        standard_execution!

        # @return [Hash]
        attr_reader :tuple

        # @return [Dry::Monads::Result]
        def call
          run_callbacks :execute do
            yield prepare!

            yield upsert!
          end

          Success()
        end

        wrapped_hook! def prepare
          @tuple = layout_instance.build_digest_attributes

          super
        end

        wrapped_hook! def upsert
          Layouts::InstanceDigest.upsert(tuple, unique_by: UNIQUE_BY, returning: nil)

          super
        end
      end
    end
  end
end
