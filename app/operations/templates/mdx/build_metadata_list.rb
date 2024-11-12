# frozen_string_literal: true

module Templates
  module MDX
    # @see Templates::MDX::MetadataListBuilder
    class BuildMetadataList < Support::SimpleServiceOperation
      service_klass Templates::MDX::MetadataListBuilder
    end
  end
end
