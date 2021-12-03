# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::Operations::UpdateGlobalConfiguration
    class UpdateGlobalConfiguration < ApplicationContract
      json do
        optional(:site).maybe(:hash) do
          required(:provider_name).filled(:string)
        end

        optional(:theme).maybe(:hash) do
          required(:color).value(included_in?: Settings::Types::COLOR_SCHEMES)
          required(:font).value(included_in?: Settings::Types::FONT_SCHEMES)
        end
      end
    end
  end
end
