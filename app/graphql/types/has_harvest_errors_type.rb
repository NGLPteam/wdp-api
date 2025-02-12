# frozen_string_literal: true

module Types
  # @see HasHarvestErrors
  module HasHarvestErrorsType
    include Types::BaseInterface

    field :harvest_errors, [::Types::HarvestErrorType, { null: false }], null: false do
      description <<~TEXT
      A list of errors that are associated with this harvesting type.
      TEXT
    end

    load_association! :harvest_errors
  end
end
