# frozen_string_literal: true

module Attributions
  module Collections
    # @see Attributions::Collections::Manage
    class ManageJob < ApplicationJob
      queue_as :maintenance

      # @return [void]
      def perform
        call_operation!("attributions.collections.manage")
      end
    end
  end
end
