# frozen_string_literal: true

module Templates
  module Digests
    module Definitions
      # @see Templates::Digests::Definitions::Upsert
      class Upserter < Support::HookBased::Actor
        include Dry::Initializer[undefined: false].define -> do
        end

        standard_execution!

        # @return [Dry::Monads::Result]
        def call
          run_callbacks :execute do
            yield prepare!
          end

          Success()
        end

        wrapped_hook! def prepare
          super
        end
      end
    end
  end
end
