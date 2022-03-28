# frozen_string_literal: true

module Schemas
  module Associations
    # An {Ordering} can be set up to handle certain {SchemaDefinition schemas}
    # and act as the "default view" for an entity rendering its descendants of
    # said type.
    class HandledSchema < Association
      include Versionless

      def blank?
        namespace.blank? || identifier.blank? || super
      end
    end
  end
end
