# frozen_string_literal: true

module Templates
  module MDX
    # @see Templates::MDX::MetadataItemBuilder
    class BuildMetadataItem < Support::SimpleServiceOperation
      service_klass Templates::MDX::MetadataItemBuilder
    end
  end
end
