# frozen_string_literal: true

module Loaders
  class ContextualPermissionLoader < GraphQL::Batch::Loader
    HAS_CACHE_KEY = AppTypes.Interface(:loader_cache_key)

    # @!attribute [r] user
    # @return [User, AnonymousUser]
    attr_reader :user

    def initialize(user)
      @user = user
    end

    # @param [<HierarchicalEntity>] entities
    # @return [void]
    def perform(entities)
      if @user.present? && !@user.anonymous?
        ContextualPermission.for_user(@user).for_hierarchical(entities).find_each do |record|
          fulfill(record, record)
        end
      end

      entities.each do |entity|
        key = cache_key(entity)

        next if fulfilled? key

        record = ContextualPermission.empty_permission_for(@user, entity)

        fulfill(key, record)
      end
    end

    protected

    # @return [String]
    def cache_key(object)
      case object
      when HAS_CACHE_KEY then object.loader_cache_key
      else
        object
      end
    end
  end
end
