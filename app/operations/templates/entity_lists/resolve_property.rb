# frozen_string_literal: true

module Templates
  module EntityLists
    # @see Templates::EntityLists::PropertyResolver
    class ResolveProperty < Support::SimpleServiceOperation
      service_klass Templates::EntityLists::PropertyResolver
    end
  end
end
