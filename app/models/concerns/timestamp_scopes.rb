# frozen_string_literal: true

module TimestampScopes
  extend ActiveSupport::Concern

  included do
    scope :in_recent_order, -> { order(created_at: :desc) }
  end

  module ClassMethods
    def latest
      in_recent_order.first
    end
  end
end
