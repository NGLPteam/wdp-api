# frozen_string_literal: true

module ScopesForUser
  extend ActiveSupport::Concern

  included do
    scope :for_user, ->(user) { recognized_user?(user) ? where(user: user) : none }
  end

  module ClassMethods
    # @param [User, AnonymousUser] user
    def recognized_user?(user)
      user.present? && !user.anonymous?
    end
  end
end
