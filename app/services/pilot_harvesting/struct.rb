# frozen_string_literal: true

module PilotHarvesting
  # @abstract
  class Struct < Dry::Struct
    extend Dry::Core::ClassAttributes
    extend Support::DoFor

    include Dry::Effects::Handler.Cache(:harvesting)
    include Dry::Effects::Handler.Resolve
    include Dry::Monads::Do.for(:upsert)
    include Dry::Monads::Do.for(:upsert_each)
    include Dry::Monads[:result]
    prepend Dry::Effects.Cache(harvesting: :find_schema)

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
    def call_operation(name, *args, **kwargs)
      result = MeruAPI::Container[name].(*args, **kwargs)

      return result unless block_given?

      handle_result(result) do |value|
        yield value
      end
    end

    def handle_result(result)
      Dry::Matcher::ResultMatcher.call result do |m|
        m.success do |res|
          yield res
        end

        m.failure do |*errs|
          Failure[*errs]
        end
      end
    end

    # @param [String] name
    # @return [SchemaVersion]
    def find_schema(name)
      SchemaVersion[schema_name]
    end

    # @abstract
    # @return [Dry::Monads::Result]
    do_for! def upsert
      # :nocov:
      raise NotImplementedError
      # :nocov:
    end

    # @param [<#upsert>] upsertables
    # @return [Dry::Monads::Result]
    def upsert_each(upsertables)
      upserted = upsertables.map do |upsertable|
        yield upsertable.upsert
      end

      Success upserted
    end

    class << self
      def for_array_option
        PilotHarvesting::Types::Array.of(self).default { [] }
      end

      def method_added(method_name)
        super

        case method_name
        when /\Aupsert\z/
          include Dry::Monads::Do.for(method_name)
        end
      end
    end
  end
end
