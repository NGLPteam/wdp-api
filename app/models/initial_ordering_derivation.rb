# frozen_string_literal: true

# This view connects a single {Ordering} to its {Entity} using logic in the database to determine
# which should be the default "initial" ordering.
#
# It first tries to select the ordering with {OrderingEntryCount the most visible entries}, and
# will then fall back to {Ordering.deterministically_ordered deterministic ordering}.
#
# @see InitialOrderingLink
# @see InitialOrderingSelection
# @see OrderingEntryCount
class InitialOrderingDerivation < ApplicationRecord
  include ScopesForEntity
  include View

  self.primary_key = %i[entity_type entity_id ordering_id]

  # @return [HierarchicalEntity]
  belongs_to_readonly :entity, polymorphic: true

  # @return [Ordering]
  belongs_to_readonly :ordering, inverse_of: :initial_ordering_derivation
end
