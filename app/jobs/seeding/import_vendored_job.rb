# frozen_string_literal: true

module Seeding
  class ImportVendoredJob < ApplicationJob
    queue_as :maintenance

    unique :until_and_while_executing, lock_ttl: 1.hour, on_conflict: :log

    # @param [#to_s] name
    # @return [void]
    def perform(name)
      call_operation! "seeding.import_vendored", name
    end
  end
end
