# frozen_string_literal: true

module Resolvers
  module Treelike
    extend ActiveSupport::Concern

    included do
      option :leaves, type: GraphQL::Types::Boolean, default: false do |scope, value|
        value ? scope.all : scope.roots
      end
    end
  end
end
