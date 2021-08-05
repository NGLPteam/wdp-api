# frozen_string_literal: true

module Links
  class CalculateScope
    include Dry::Monads[:do, :result]

    # @return [Dry::Monads::Result::Success(String)]
    # @return [Dry::Monads::Result::Failure(Symbol, String)]
    def call(source, target)
      source_name = yield stringify_part(:source, source)
      target_name = yield stringify_part(:target, target)

      merged = "#{source_name}.linked.#{target_name}"

      Links::Types::Scope.try(merged).to_monad.or do |(_err, non_scope)|
        Failure[:invalid_scope, "#{non_scope.inspect} is not a valid scope"]
      end
    end

    private

    def stringify_part(key, value)
      case value
      when Links::Types.Interface(:model_name)
        value.model_name.to_s
      when String, Symbol
        value.to_s
      end.then do |part|
        if part.present?
          Success part.tableize
        else
          Failure[:"invalid_#{key}", "Invalid #{key}: #{value.inspect}"]
        end
      end
    end
  end
end
