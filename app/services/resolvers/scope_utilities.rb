# frozen_string_literal: true

module Resolvers
  module ScopeUtilities
    extend ActiveSupport::Concern

    def scope_wraps?(scope, model)
      case scope
      when ActiveRecord::Relation
        model == scope.model
      # :nocov:
      when model
        true
      else
        false
      end
      # :nocov:
    end
  end
end
