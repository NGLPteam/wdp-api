# frozen_string_literal: true

module Templates
  module MDX
    # @see Templates::MDX::VariablePrecisionDateBuilder
    class BuildVariablePrecisionDate < Support::SimpleServiceOperation
      service_klass Templates::MDX::VariablePrecisionDateBuilder
    end
  end
end
