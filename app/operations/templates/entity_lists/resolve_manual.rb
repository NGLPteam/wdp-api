# frozen_string_literal: true

module Templates
  module EntityLists
    # @see Templates::EntityLists::ManualResolver
    class ResolveManual < Support::SimpleServiceOperation
      service_klass Templates::EntityLists::ManualResolver
    end
  end
end
