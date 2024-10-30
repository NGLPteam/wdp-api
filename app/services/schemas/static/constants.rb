# frozen_string_literal: true

module Schemas
  module Static
    module Constants
      extend ActiveSupport::Concern

      SCHEMAS_ROOT = Rails.root.join("lib", "schemas", "definitions")

      # Schemas in these namespaces are considered "core" and ship with NGLP, rather
      # than being something custom created by end-users.
      BUILTIN_NAMESPACES = %w[cvocab default nglp testing].freeze
    end
  end
end
