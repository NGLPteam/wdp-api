# frozen_string_literal: true

# {HierarchicalEntity An entity} has the option to select an {Ordering} directly
# to serve as its initial ordering rather than relying on what is provided by
# {InitialOrderingDerivation}.
class InitialOrderingSelection < ApplicationRecord
  include ScopesForEntity
  include TimestampScopes

  belongs_to :entity, polymorphic: true, inverse_of: :initial_ordering_selection

  belongs_to :ordering, inverse_of: :initial_ordering_selection
end
