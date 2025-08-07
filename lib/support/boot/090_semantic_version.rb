# frozen_string_literal: true

require "active_record/connection_adapters/postgresql_adapter"
require_relative "../../global_types/parsed_semantic_version"
require_relative "../../global_types/semantic_version"

module Patches
  module SupportSemanticVersion
    def initialize_type_map(m = type_map)
      super

      m.register_type "parsed_semver", GlobalTypes::ParsedSemanticVersion.new
      m.register_type "semantic_version", GlobalTypes::SemanticVersion.new
    end
  end

  # An extension for StoreModel that makes sure to serialize attributes with
  # their custom serialization logic rather than relying on `#as_json`.
  module SerializeSpecialAttributesProperly
    def as_json(options = {})
      super.merge(properly_serialized_attributes)
    end

    def properly_serialized_attributes
      self.class.special_attribute_types.each_with_object({}) do |(key, value), attrs|
        attrs[key] = value.serialize_for_store_model attributes.fetch(key)
      end
    end

    module ClassMethods
      def special_attribute_types
        attribute_types.select do |_, value|
          value.respond_to?(:serialize_for_store_model)
        end
      end
    end

    module ClassMethodsInclusion
      def included(base)
        super if defined?(super)

        base.extend Patches::SerializeSpecialAttributesProperly::ClassMethods
      end
    end

    class << self
      def prepended(base)
        base.singleton_class.prepend ClassMethodsInclusion
      end
    end
  end
end

ActiveSupport.on_load(:active_record_postgresqladapter) do
  prepend Patches::SupportSemanticVersion
end

StoreModel::Model.prepend Patches::SerializeSpecialAttributesProperly
