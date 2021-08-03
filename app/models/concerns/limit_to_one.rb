# frozen_string_literal: true

module LimitToOne
  extend ActiveSupport::Concern

  module ClassMethods
    # @raise [ActiveRecord::RecordNotFound]
    # @raise [LimitToOne::TooManyMatches]
    # @return [ApplicationRecord]
    def only_one!
      found_count = limit(2).count

      raise TooManyMatches, "too many matches for scope" if found_count > 1

      first!
    end

    # @raise [LimitToOne::TooManyMatches]
    # @return [ApplicationRecord]
    def only_one_or_initialize
      found_count = limit(2).count

      raise TooManyMatches, "too many matches for scope" if found_count > 1

      first_or_initialize
    end
  end

  # @api private
  class TooManyMatches < StandardError; end
end
