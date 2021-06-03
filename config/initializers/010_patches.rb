# frozen_string_literal: true

require "active_record/connection_adapters/postgresql_adapter"

module Patches
  module SupportLQuery
    def initialize_type_map(m = type_map)
      super

      m.register_type "lquery", ActiveRecord::ConnectionAdapters::PostgreSQL::OID::SpecializedString.new(:lquery)
    end
  end
end

ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.prepend Patches::SupportLQuery
