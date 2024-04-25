# frozen_string_literal: true

module Patches
  module GraphQLUseActiveSupportInflection
    def camelize(string)
      ::ActiveSupport::Inflector.camelize(string, false)
    end

    def underscore(string)
      ::ActiveSupport::Inflector.underscore(string)
    end

    def constantize(string)
      ::ActiveSupport::Inflector.constantize(string)
    end
  end
end

GraphQL::Schema::Member::BuildType.singleton_class.prepend(Patches::GraphQLUseActiveSupportInflection)
