# frozen_string_literal: true

module PilotHarvesting
  # @abstract
  class Struct < Dry::Struct
    extend Dry::Core::ClassAttributes

    include Dry::Effects::Handler.Resolve
    include Dry::Monads[:result]

    defines

    transform_keys(&:to_sym)

    transform_types do |type|
      if type.default?
        type.constructor do |value|
          value.nil? ? Dry::Types::Undefined : value
        end
      else
        type
      end
    end

    # @return [Dry::Monads::Result]
    def call_operation(name, *args)
      result = WDPAPI::Container[name].(*args)

      return result unless block_given?

      Dry::Matcher::ResultMatcher.call result do |m|
        m.success do |res|
          yield res
        end

        m.failure do |*errs|
          Failure[*errs]
        end
      end
    end
  end
end
