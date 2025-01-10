# frozen_string_literal: true

module Templates
  module Definitions
    # @see Templates::Instances::HasSeeAllOrdering
    # @see Types::TemplateHasSeeAllOrderingType
    module HasSeeAllOrdering
      extend ActiveSupport::Concern
      extend DefinesMonadicOperation
    end
  end
end
