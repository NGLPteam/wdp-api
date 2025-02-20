# frozen_string_literal: true

module Schemas
  module Orderings
    TypeRegistry = Support::Schemas::TypeContainer.new.configure do |tc|
      tc.add! :ancestor_name, Schemas::Orderings::Types::AncestorName
      tc.add! :order_builder_name, Schemas::Orderings::Types::OrderBuilderName
      tc.add! :static_property_type, Schemas::Orderings::Types::StaticPropertyType
    end
  end
end
