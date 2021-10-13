# frozen_string_literal: true

module ScopesForIdentifier
  extend ActiveSupport::Concern

  included do
    scope :by_identifier, ->(identifier) { where(identifier: identifier) }
  end
end
