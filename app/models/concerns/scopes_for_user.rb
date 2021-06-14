# frozen_string_literal: true

module ScopesForUser
  extend ActiveSupport::Concern

  module ClassMethods
    # @param [User, AnonymousUser, nil] user
    # @return [ActiveRecord::Relation]
    def for_user(user)
      recognized_user?(user) ? where(user: user) : none
    end

    # @param [User, AnonymousUser] user
    def recognized_user?(user)
      user.present? && !user.anonymous?
    end
  end
end
