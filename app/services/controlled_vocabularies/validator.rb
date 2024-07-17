# frozen_string_literal: true

module ControlledVocabularies
  class Validator < Support::HookBased::Actor
    include Dry::Effects::Handler.State(:depth)
    include Dry::Effects::Handler.State(:item_identifiers)

    include Dry::Initializer[undefined: false].define -> do
      param :input, Types::Input
    end

    standard_execution!

    # @return [ControlledVocabularies::Contracts::Root]
    attr_reader :root_contract

    # @return [Set<String>]
    attr_reader :item_identifiers

    # @return [Dry::Validation::Result]
    attr_reader :result

    def call
      run_callbacks :execute do
        yield prepare!

        yield validate!
      end

      Success result.to_h
    end

    wrapped_hook! def prepare
      @item_identifiers = Set.new
      @result = nil
      @root_contract = MeruAPI::Container["controlled_vocabularies.contracts.root"]

      super
    end

    wrapped_hook! def validate
      @result = root_contract.(input)

      yield @result

      super
    end

    around_validate :provide_depth!

    around_validate :provide_item_identifiers!

    private

    # @return [void]
    def provide_depth!
      with_depth(0) do
        yield
      end
    end

    # @return [void]
    def provide_item_identifiers!
      with_item_identifiers(item_identifiers) do
        yield
      end
    end
  end
end
