# frozen_string_literal: true

module Templates
  module MDX
    # @see Templates::MDX::CopyLinkBuilder
    class BuildCopyLink < Support::SimpleServiceOperation
      service_klass Templates::MDX::CopyLinkBuilder
    end
  end
end
