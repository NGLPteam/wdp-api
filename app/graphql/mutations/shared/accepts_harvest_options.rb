# frozen_string_literal: true

module Mutations
  module Shared
    module AcceptsHarvestOptions
      extend ActiveSupport::Concern

      included do
        argument :mapping_options, Types::HarvestOptionsMappingInputType, required: false, default_value: {}, replace_null_with_default: true do
          description <<~TEXT
          Options that control mapping of entities during the harvesting process.
          TEXT
        end

        argument :read_options, Types::HarvestOptionsReadInputType, required: false, default_value: {}, replace_null_with_default: true do
          description <<~TEXT
          Options that control reading from the source.
          TEXT
        end
      end
    end
  end
end
