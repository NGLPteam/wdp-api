# frozen_string_literal: true

# This namespace contains the actual classes that expose mutations
# to the {APISchema GraphQL Schema}.
#
# @subsystem GraphQL
# @see MutationOperations
module Mutations
  # Classes in this namespace can be referenced by any mutation via
  # {MutationOperations::Contracts.use_contract!}, using the demodulized,
  # parameterized version of their name.
  module Contracts
  end

  # Classes in this namespace act as operations and implement the actual logic
  # for a mutation. Their lifecycle is described in {MutationOperations::Base}
  # and provide a standard protocol for handling validation, errors, and hooks.
  module Operations
  end

  # Concerns that can be added to some {Mutations::Operations mutation operations}
  # but do not have universal applicability enough to warrant being a DSL method.
  module Shared
  end

  # Utility operations are designed to be assist with {Mutations::Operations} classes,
  # but are not themselves a mutation.
  module Utility
  end
end
