# frozen_string_literal: true

module Templates
  module MDX
    # @see Templates::MDX::MetadataLabelBuilder
    class BuildMetadataLabel < Support::SimpleServiceOperation
      service_klass Templates::MDX::MetadataLabelBuilder
    end
  end
end
