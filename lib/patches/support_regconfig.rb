# frozen_string_literal: true

require "active_record/connection_adapters/postgresql_adapter"

module Patches
  module SupportRegconfig
    def initialize_type_map(m = type_map)
      super

      m.register_type "regconfig", ActiveRecord::ConnectionAdapters::PostgreSQL::OID::SpecializedString.new(:regconfig)
    end
  end
end

ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.prepend Patches::SupportRegconfig
