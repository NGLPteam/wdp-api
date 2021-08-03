# frozen_string_literal: true

module SchematicReference
  extend ActiveSupport::Concern

  included do
    belongs_to :referrer, polymorphic: true
    belongs_to :referent, polymorphic: true

    scope :by_referrer, ->(referrer) { where(referrer: referrer) }
    scope :by_referent, ->(referent) { where(referent: referent) }
    scope :by_path, ->(path) { where(path: path) }
  end
end
