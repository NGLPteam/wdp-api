# frozen_string_literal: true

module Templates
  module MDX
    # @see Templates::MDX::AnchorBuilder
    class BuildAnchor < Support::SimpleServiceOperation
      service_klass Templates::MDX::AnchorBuilder
    end
  end
end
