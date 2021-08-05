# frozen_string_literal: true

module Links
  # @see Links::ValidateConnection
  class Connect
    include Dry::Monads[:do, :result]
    include WDPAPI::Deps[validate: "links.validate_connection"]
    include MonadicPersistence

    prepend TransactionalCall

    # @param [HierarchicalEntity] source
    # @param [HierarchicalEntity] target
    # @param [String] operator
    # @return [Dry::Monads::Result::Success(EntityLink)]
    # @return [Dry::Monads::Result::Failure]
    def call(source, target, operator)
      validated = yield validate.call(source: source, target: target, operator: operator)

      link = EntityLink.by_source(validated[:source]).by_target(validated[:target]).first_or_initialize

      link.operator = validated[:operator]

      monadic_save link
    end
  end
end
