# frozen_string_literal: true

module Templates
  module MDX
    # @see Templates::MDX::EntityLinkBuilder
    class BuildEntityLink < Support::SimpleServiceOperation
      service_klass Templates::MDX::EntityLinkBuilder
    end
  end
end
