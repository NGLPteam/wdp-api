# frozen_string_literal: true

module Types
  # @see Templates::Definitions::HasSeeAllOrdering
  # @see Templates::Instances::HasSeeAllOrdering
  module TemplateHasSeeAllOrderingType
    include Types::BaseInterface

    description <<~TEXT
    An interface for a template instance that exposes an `Ordering`
    in order to to link to see all associated records.
    TEXT

    field :see_all_ordering, ::Types::OrderingType, null: true do
      description <<~TEXT
      The ordering to render for a "see all" link.
      TEXT
    end

    load_association! :see_all_ordering
  end
end
