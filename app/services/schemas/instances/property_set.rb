# frozen_string_literal: true

module Schemas
  module Instances
    class PropertySet
      include StoreModel::Model

      attribute :schema, Schemas::Instances::VersionDeclaration.to_type, default: proc { {} }
      attribute :values, :indifferent_hash, default: proc { {} }
    end
  end
end
