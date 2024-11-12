# frozen_string_literal: true

module Templates
  module Drops
    class SchemaVersionDrop < Templates::Drops::AbstractDrop
      # @param [SchemaVersion] schema_version
      def initialize(schema_version)
        super()

        @schema_version = schema_version
      end

      delegate :declaration, :label, :name, to: :@schema_version

      alias to_s label
    end
  end
end
