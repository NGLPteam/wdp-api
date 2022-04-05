# frozen_string_literal: true

# Scopes for a model that has an `identifier` attribute.
#
# It is not guaranteed to be unique globally, as it may be scoped to a certain
# position in the hierarchy, such as with {Collection} and {Item}, or certain
# parent models, as with {Ordering}, {HarvestSet}, {HarvestEntity}, etc.
#
# @see GloballyUniqueIdentifier
module ScopesForIdentifier
  extend ActiveSupport::Concern

  included do
    scope :by_identifier, ->(identifier) { where(identifier: identifier) }
  end

  class_methods do
    # @param [String, ApplicationRecord, AppTypes::UUID] identifier_or_record
    # @return [ActiveRecord::Relation]
    def identified_by(identifier_or_record)
      case identifier_or_record
      when self, AppTypes::UUID
        where(primary_key => identifier_or_record)
      when String
        by_identifier(identifier_or_record)
      else
        none
      end
    end

    # Find or initialize a record by its identifier
    # from the current scope.
    #
    # @param [String] identifier
    # @return [ApplicationRecord]
    def to_upsert_by_identifier(identifier)
      by_identifier(identifier).first_or_initialize
    end
  end
end
