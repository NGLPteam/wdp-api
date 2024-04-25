# frozen_string_literal: true

require "active_record/connection_adapters/abstract/schema_definitions"

module Patches
  module UseProperTimestamps
    # Ensure that the default for created/updated at is always set
    CURRENT_TIMESTAMP = -> { "CURRENT_TIMESTAMP" }

    def timestamps(**options)
      options[:null] = false
      options[:default] = CURRENT_TIMESTAMP

      super(**options)
    end
  end
end

ActiveRecord::ConnectionAdapters::TableDefinition.prepend Patches::UseProperTimestamps
