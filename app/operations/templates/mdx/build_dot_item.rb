# frozen_string_literal: true

module Templates
  module MDX
    # @see Templates::MDX::DotItemBuilder
    class BuildDotItem < Support::SimpleServiceOperation
      service_klass Templates::MDX::DotItemBuilder
    end
  end
end
