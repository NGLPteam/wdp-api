# frozen_string_literal: true

# Equivalent to {EntityAncestor}, except it is cached in order to use with
# dynamic orderings in order to address performance issues on very large
# entity trees.
#
# @see Entities::RefreshCachedAncestors
class EntityCachedAncestor < ApplicationRecord
  include HasEphemeralSystemSlug
  include MaterializedView
end
