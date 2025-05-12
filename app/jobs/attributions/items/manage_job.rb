# frozen_string_literal: true

module Attributions
  module Items
    # @see Attributions::Collections::Manage
    class ManageJob < ApplicationJob
      queue_as :maintenance

      unique_job! by: :job

      # @return [void]
      def perform
        call_operation!("attributions.items.manage")
      end
    end
  end
end
