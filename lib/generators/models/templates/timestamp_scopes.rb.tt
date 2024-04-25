# frozen_string_literal: true

# Common methods for working with standard Rails timestamps.
module TimestampScopes
  extend ActiveSupport::Concern

  included do
    scope :in_recent_order, -> { order(created_at: :desc) }
    scope :in_oldest_order, -> { order(created_at: :asc) }
    scope :most_recently_updated, -> { order(updated_at: :desc) }
    scope :least_recently_updated, -> { order(updated_at: :asc) }
  end

  class_methods do
    # @return [ApplicationRecord, nil]
    def latest
      in_recent_order.first
    end

    # @return [ApplicationRecord, nil]
    def oldest
      in_oldest_order.first
    end
  end
end
