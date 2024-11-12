# frozen_string_literal: true

module Templates
  module MDX
    # @see Templates::MDX::AssetBuilder
    class BuildAsset < Support::SimpleServiceOperation
      service_klass Templates::MDX::AssetBuilder
    end
  end
end
