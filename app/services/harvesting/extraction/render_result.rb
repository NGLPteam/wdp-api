# frozen_string_literal: true

module Harvesting
  module Extraction
    class RenderResult < Support::FlexibleStruct
      include Dry::Core::Constants
      include Dry::Monads[:result]

      attribute :config, RenderConfig
      attribute :data, Types::Hash.map(Types::Coercible::String, Types::Any).default(EMPTY_HASH)
      attribute :instance_assigns, Types::Hash.map(Types::Coercible::String, Types::Any).default(EMPTY_HASH)
      attribute :errors, Types::Array.of(Harvesting::Extraction::Error).default(EMPTY_ARRAY)

      attribute :output, Types::StrippedString

      attribute? :no_template, Types::Bool.default(false)
      attribute? :skip_process, Types::Bool.default(false)

      alias no_template? no_template

      delegate :value_or, to: :to_monad

      # @see RenderConfig#process
      # @return [Dry::Monads::Result]
      def to_monad
        if no_template?
          Success(nil)
        elsif valid?
          skip_process ? Success(self) : config.process(self)
        else
          Failure[:cannot_render, self]
        end
      end

      def to_validator_attributes
        { data:, output:, }
      end

      def valid?
        errors.blank?
      end
    end
  end
end
