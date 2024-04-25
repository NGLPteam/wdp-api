# frozen_string_literal: true

module Seeding
  class ImportVendoredJob < ApplicationJob
    queue_as :maintenance

    unique_job! by: :first_arg

    # @param [#to_s] name
    # @return [void]
    def perform(name)
      call_operation! "seeding.import_vendored", name
    end
  end
end
