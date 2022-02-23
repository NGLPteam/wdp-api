# frozen_string_literal: true

module ScopesForUser
  extend ActiveSupport::Concern

  class_methods do
    # @param [User, AnonymousUser, <User>, ActiveRecord::Relation<User>, nil] user
    # @return [ActiveRecord::Relation]
    def for_user(user)
      recognized_user?(user) ? where(user: user) : for_anonymous_user
    end

    # @see {.for_user}
    # @abstract
    # @return [ActiveRecord::Relation]
    def for_anonymous_user
      none
    end

    # @param [User, AnonymousUser, <User>, ActiveRecord::Relation<User>, nil] user
    def recognized_user?(user)
      return user.model == ::User if user.kind_of?(ActiveRecord::Relation)
      return user.all? { |u| u.kind_of?(::User) } if user.kind_of?(Array)

      user.present? && !user.anonymous?
    end
  end
end
