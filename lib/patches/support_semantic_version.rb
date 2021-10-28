# frozen_string_literal: true

require "active_record/connection_adapters/postgresql_adapter"
require_relative "../global_types/parsed_semantic_version"
require_relative "../global_types/semantic_version"

module Patches
  module SupportSemanticVersion
    def initialize_type_map(m = type_map)
      super

      m.register_type "parsed_semver", GlobalTypes::ParsedSemanticVersion.new
      m.register_type "semantic_version", GlobalTypes::SemanticVersion.new
    end
  end
end

ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.prepend Patches::SupportSemanticVersion
