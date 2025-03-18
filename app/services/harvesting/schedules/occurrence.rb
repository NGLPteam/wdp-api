# frozen_string_literal: true

module Harvesting
  module Schedules
    class Occurrence < Support::FlexibleStruct
      include Dry::Core::Equalizer.new(:scheduling_key)
      include Dry::Core::Memoizable
      include Digestable

      attribute :frequency_expression, Harvesting::Schedules::Types::FrequencyExpression

      attribute :scheduled_at, Harvesting::Schedules::Types::Params::Time

      memoize def scheduling_key
        digest_with do |dig|
          dig << frequency_expression
          dig << scheduled_at.iso8601(0)
        end
      end
    end
  end
end
