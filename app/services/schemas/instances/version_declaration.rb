# frozen_string_literal: true

module Schemas
  module Instances
    class VersionDeclaration
      include StoreModel::Model

      attribute :id, :string
      attribute :namespace, :string
      attribute :identifier, :string
      attribute :version, :string

      validates :id, presence: true
    end
  end
end
