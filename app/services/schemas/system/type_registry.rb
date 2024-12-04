# frozen_string_literal: true

module Schemas
  module System
    # The type registry used by {Schemas::System} and related records.
    #
    # @see SchemaPropertyKind
    # @see SchemaPropertyType
    TypeRegistry = Support::Schemas::TypeContainer.new.configure do |tc|
      tc.add! :kind_name, Schemas::System::Types::KindName
      tc.add! :type_name, Schemas::System::Types::TypeName
    end
  end
end
