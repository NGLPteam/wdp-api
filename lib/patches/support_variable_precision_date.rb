# frozen_string_literal: true

require "active_record/connection_adapters/postgresql_adapter"

require_relative "../global_types/variable_precision_date"

module Patches
  module SupportVariablePrecisionDate
    def initialize_type_map(m = type_map)
      super

      m.register_type "variable_precision_date", GlobalTypes::VariablePrecisionDate.new
    end
  end
end

ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::NATIVE_DATABASE_TYPES.merge!(variable_precision_date: { name: "variable_precision_date" })
ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.prepend Patches::SupportVariablePrecisionDate
