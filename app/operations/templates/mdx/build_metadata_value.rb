# frozen_string_literal: true

module Templates
  module MDX
    # @see Templates::MDX::MetadataValueBuilder
    class BuildMetadataValue < Support::SimpleServiceOperation
      service_klass Templates::MDX::MetadataValueBuilder
    end
  end
end
