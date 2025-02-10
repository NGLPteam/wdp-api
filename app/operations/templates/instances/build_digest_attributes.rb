# frozen_string_literal: true

module Templates
  module Instances
    # @see Templates::Instances::DigestAttributesBuilder
    class BuildDigestAttributes < Support::SimpleServiceOperation
      service_klass Templates::Instances::DigestAttributesBuilder
    end
  end
end
