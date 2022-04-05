# frozen_string_literal: true

# A model that has an `identifier` attribute
# that is globally unique for its type.
#
# @see Community
# @see HarvestSource
# @see ScopesForIdentifier
module GloballyUniqueIdentifier
  extend ActiveSupport::Concern

  include ScopesForIdentifier

  included do
    validates :identifier, uniqueness: true
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
