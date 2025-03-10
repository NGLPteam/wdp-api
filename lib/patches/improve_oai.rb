# frozen_string_literal: true

module Patches
  module ImproveOAI
    module ResponseImprovements
      # @return [Integer, nil]
      attr_reader :complete_list_size

      def initialize(...)
        super

        rt_node = xpath_first(doc, ".//resumptionToken")

        @complete_list_size = get_attribute(rt_node, "completeListSize").try(:value)&.to_i
      end
    end
  end
end

OAI::Response.prepend Patches::ImproveOAI::ResponseImprovements
