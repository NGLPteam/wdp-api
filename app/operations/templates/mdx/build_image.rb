# frozen_string_literal: true

module Templates
  module MDX
    # @see Templates::MDX::ImageBuilder
    class BuildImage < Support::SimpleServiceOperation
      service_klass Templates::MDX::ImageBuilder
    end
  end
end
