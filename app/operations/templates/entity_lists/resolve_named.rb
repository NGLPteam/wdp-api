# frozen_string_literal: true

module Templates
  module EntityLists
    # @see Templates::EntityLists::NamedResolver
    class ResolveNamed < Support::SimpleServiceOperation
      service_klass Templates::EntityLists::NamedResolver
    end
  end
end
