# frozen_string_literal: true

module ScopesForIdentifier
  extend ActiveSupport::Concern

  included do
    scope :by_identifier, ->(identifier) { where(identifier: identifier) }
  end

  class_methods do
    # @param [String] identifier
    # @raise [ActiveRecord::RecordNotFound]
    # @return [ApplicationRecord]
    def by_identifier!(identifier)
      by_identifier(identifier).first!
    end
  end
end
