# frozen_string_literal: true

module Templates
  module ManualLists
    # @see Templates::ManualLists::Assigner
    class Assign < Support::SimpleServiceOperation
      service_klass Templates::ManualLists::Assigner
    end
  end
end
