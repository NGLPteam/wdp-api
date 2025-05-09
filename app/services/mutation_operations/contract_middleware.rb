# frozen_string_literal: true

module MutationOperations
  # The minimum amount needed to run a {MutationOperations::Contract}.
  #
  # This class mostly exists to simplify testing, as the values herein are set
  # by the more extensive {MutationOperations::Middleware}.
  #
  # @api private
  class ContractMiddleware
    include Dry::Effects::Handler.Resolve
    include Dry::Initializer[undefined: false].define -> do
      option :current_user, ::Users::Types::Current, default: ::Users::Types::DEFAULT
      option :local_context, Support::GlobalTypes::Hash, default: proc { {} }
      option :edges, Support::GlobalTypes::Hash, default: proc { {} }
    end

    # @return [void]
    def call
      local_context[:edges] ||= edges
      local_context[:edges].freeze

      provide(current_user:, local_context:) do
        yield
      end
    end
  end
end
