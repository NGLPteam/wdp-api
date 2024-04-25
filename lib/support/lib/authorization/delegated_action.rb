# frozen_string_literal: true

module Support
  module Authorization
    # A type that simply maps one action to another when resolving
    # whether or not something can be done, based on the current value.
    #
    # i.e. `policy.index?` being delegated to `policy.read?`, without
    # having to redefine `index?` in an inherited policy if it alters
    # the conditions needed to satisfy `read`.
    class DelegatedAction < Support::FlexibleStruct
      attribute :from, Types::ActionName
      attribute :to, Types::ActionName

      # @param [Support::Authorization::DefinesActions] context
      # @return [Dry::Monads::Validated]
      def call(context)
        context.resolve_action(to)
      end
    end
  end
end
