# frozen_string_literal: true

module Templates
  module Tags
    module Helpers
      extend ActiveSupport::Concern

      private

      def call_operation!(name, ...)
        MeruAPI::Container[name].call(...).value!
      end
    end
  end
end
