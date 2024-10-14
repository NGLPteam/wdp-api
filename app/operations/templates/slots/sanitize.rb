# frozen_string_literal: true

module Templates
  module Slots
    class Sanitize
      include Dry::Monads[:result]

      HEADERS = %w[h1 h2 h3 h4 h5 h6].freeze

      BLOCK = ::Sanitize::Config.merge(::Sanitize::Config::BASIC,
        elements: ::Sanitize::Config::BASIC[:elements] + HEADERS,
      )

      INLINE = ::Sanitize::Config.merge(::Sanitize::Config::RESTRICTED,
        elements: ::Sanitize::Config::RESTRICTED[:elements] + %w[span],
      )

      # @param [String] content
      # @param [Templates::Types::SlotKind] kind
      # @return [Dry::Monads::Success(String)]
      def call(content, kind: "block")
        config = config_for(kind)

        return Failure[:unknown_slot_kind, kind] unless config

        Success ::Sanitize.fragment(content, config)
      end

      private

      # @param [Templates::Types::SlotKind] kind
      # @return [Hash, false]
      def config_for(kind)
        case kind.to_s
        in "block"
          BLOCK
        in "inline"
          INLINE
        else
          false
        end
      end
    end
  end
end
