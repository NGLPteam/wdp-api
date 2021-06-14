# frozen_string_literal: true

class PermissionDefinition < FrozenRecord::Base
  add_index :path, unique: true
  add_index :kind

  self.primary_key = "path"

  scope :by_kind, ->(kind) { where(kind: kind.to_s) }
  scope :contextual, -> { by_kind(:contextual) }
  scope :global, -> { by_kind(:global) }

  class << self
    # @return [<Hash>]
    def to_sync
      all.map(&:as_json)
    end
  end
end
