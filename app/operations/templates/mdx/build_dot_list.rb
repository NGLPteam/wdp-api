# frozen_string_literal: true

module Templates
  module MDX
    # @see Templates::MDX::DotListBuilder
    class BuildDotList < Support::SimpleServiceOperation
      service_klass Templates::MDX::DotListBuilder
    end
  end
end
