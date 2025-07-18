# frozen_string_literal: true

module Harvesting
  module Extraction
    class RenderConfig < Support::FlexibleStruct
      include Dry::Core::Equalizer.new(:name)
      include Dry::Monads[:result]
      include Dry::Monads::Do.for(:process)

      Map = Types::Hash.map(Types::Coercible::Symbol, self)

      attribute :name, Types::Coercible::Symbol

      attribute? :data, Types::Bool.default(false)
      attribute? :finesser, Types.Interface(:call).optional
      attribute? :type, Types.Instance(Dry::Types::Type).default(Types::Any)

      attribute :validator, Types.Inherits(RenderValidator)

      def callback_name
        :"render_#{name}"
      end

      alias data? data

      def finesser?
        !finesser.nil?
      end

      # @param [Harvesting::Extraction::RenderResult] result
      # @return [Dry::Monads::Result]
      def process(result)
        yield validate(result)

        finessed = finesse result

        coerced = type[finessed]
      rescue Dry::Types::CoercionError, Dry::Types::ConstraintError => e
        Failure[:cannot_coerce, e.message]
      else
        Success coerced
      end

      private

      # @param [Harvesting::Extraction::RenderResult] result
      # @return [Object]
      def finesse(result)
        if finesser?
          finesser.(result)
        elsif data?
          result.data
        else
          result.output.strip
        end
      end

      def validate(result)
        validator.new(**result.to_validator_attributes).to_monad
      end
    end
  end
end
