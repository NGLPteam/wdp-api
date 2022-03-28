# frozen_string_literal: true

module Schemas
  module Associations
    # Some associations only apply to {SchemaDefinition} and
    # should not specify their version.
    module Versionless
      extend ActiveSupport::Concern

      def requirement
        schema_definition_identifier
      end
    end
  end
end
