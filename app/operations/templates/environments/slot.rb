# frozen_string_literal: true

module Templates
  module Environments
    class Slot
      include Dry::Monads[:result]

      # @param [Templates::Types::SlotKind] kind
      # @return [Dry::Monads::Success(Liquid::Environment)]
      def call(kind: "block")
        environment = Liquid::Environment.build do |env|
          case kind
          in "block"
            # block-level configurations
            env.block
          in "inline"
            # inline-level configurations
            env.inline
          end
        end

        Success environment
      end
    end
  end
end
