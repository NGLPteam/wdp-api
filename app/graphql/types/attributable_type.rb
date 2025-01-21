# frozen_string_literal: true

module Types
  module AttributableType
    include Types::BaseInterface

    description "A record that can retrieve flattened contributions"

    field :attributions, [Types::AttributionType, { null: false }], null: false do
      description "A priority-ordered list of attributions for the record."
    end
  end
end
