# frozen_string_literal: true

module StaticSchemaRecord
  extend ActiveSupport::Concern

  ROOT = Rails.root.join("lib", "schemas", "definitions")

  included do
    scope :by_namespace, ->(ns) { where(namespace: ns.to_s) }

    scope :cvocab, -> { where(namespcae: "cvocab") }
    scope :default, -> { where(namespace: "default") }
    scope :nglp, -> { where(namespace: "nglp") }

    add_index :namespace
  end
end
