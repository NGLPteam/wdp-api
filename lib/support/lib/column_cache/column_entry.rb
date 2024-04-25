# frozen_string_literal: true

module Support
  module ColumnCache
    class ColumnEntry < ::Support::FlexibleStruct
      attribute :id, Types::String
      attribute :model_name, Types::String
      attribute :table_name, Types::String
      attribute :name, Types::String
      attribute :type, Types::Coercible::String
      attribute :null, Types::SafeBoolean

      attribute :sql_type_metadata, Types::Coercible::Hash.fallback { {} }
      attribute :default, Types::String.optional
      attribute :default_function, Types::String.optional

      attribute :has_default, Types::SafeBoolean
      attribute :virtual, Types::SafeBoolean
    end
  end
end
