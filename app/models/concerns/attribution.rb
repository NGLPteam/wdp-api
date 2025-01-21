# frozen_string_literal: true

# An attribution is a "flattened" version of a {Contribution} record,
# allowing a single attribution record per {Contributable} for each
# {Contributor}, ranked by the derived priorities of the associated roles.
module Attribution
  extend ActiveSupport::Concern
  extend DefinesMonadicOperation

  included do
    scope :in_default_order, -> { reorder(position: :asc) }
  end
end
