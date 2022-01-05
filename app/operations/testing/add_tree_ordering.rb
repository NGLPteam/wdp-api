# frozen_string_literal: true

module Testing
  # @api private
  class AddTreeOrdering
    include Dry::Monads[:do, :result]
    include MonadicPersistence

    # @param [SchemaInstance] entity
    # @return [Ordering]
    def call(entity)
      adder = Testing::TreeOrderingAdder.new

      adder.call entity
    end
  end
end
