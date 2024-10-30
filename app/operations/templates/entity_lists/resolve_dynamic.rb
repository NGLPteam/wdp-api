# frozen_string_literal: true

module Templates
  module EntityLists
    # @see Templates::EntityLists::DynamicResolver
    class ResolveDynamic < Support::SimpleServiceOperation
      service_klass Templates::EntityLists::DynamicResolver
    end
  end
end
