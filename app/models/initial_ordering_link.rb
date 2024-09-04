# frozen_string_literal: true

# A join table used to actually connect {HierarchicalEntity an entity} and {Ordering}
# to act as its initial ordering. It is automatically maintained by an operation when
# orderings are refreshed as part of normal entity lifecycles.
#
# It can also be recalculated system-wide on demand through a job:
# {Schemas::Orderings::CalculateInitialJob}.
#
# @see InitialOrderingDerivation
# @see InitialOrderingSelection
# @see Schemas::Orderings::CalculateInitial
# @see Schemas::Orderings::CalculateInitialJob
class InitialOrderingLink < ApplicationRecord
  include ScopesForEntity
  include TimestampScopes

  pg_enum! :kind, as: "initial_ordering_kind"

  belongs_to :entity, polymorphic: true, inverse_of: :initial_ordering_link

  belongs_to :ordering, inverse_of: :initial_ordering_link

  scope :to_purge, -> { joins(:ordering).merge(Ordering.disabled) }
end
