# frozen_string_literal: true

module Harvesting
  module Dispatch
    class BuildLogger
      include Dry::Monads[:result]

      def call(model)
        case model
        when HarvestAttempt
          Success Harvesting::Logs::Attempt.new model
        when HarvestSource
          Success Harvesting::Logs::Source.new model
        else
          Success Harvesting::Logs::Null.new
        end
      end
    end
  end
end
