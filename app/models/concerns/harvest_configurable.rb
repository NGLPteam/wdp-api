# frozen_string_literal: true

# A record that generates a {HarvestConfiguration} for use.
module HarvestConfigurable
  extend ActiveSupport::Concern
  extend DefinesMonadicOperation

  # @see Harvesting::Configurations::Create
  # @see Harvesting::Configurations::Creator
  monadic_operation! def create_configuration(...)
    call_operation("harvesting.configurations.create", self, ...)
  end
end
