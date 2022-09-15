# frozen_string_literal: true

module Testing
  class FakeTimesGenerator
    include Dry::Core::Memoizable
    include Dry::Initializer[undefined: false].define -> do
      param :range_start, Testing::Types::Date, default: proc { 100.days.ago.to_date }
      param :range_end, Testing::Types::Date, default: proc { Date.current }

      option :initial_start_time, Testing::Types::Time, default: proc { range_start.beginning_of_day }
      option :max_time, Testing::Types::Time, default: proc { Time.current }
      option :threshold, Testing::Types::Integer.constrained(included_in: 1..100), default: proc { 25 }
      option :times_per_day_min, Testing::Types::Integer.constrained(included_in: 1..10), default: proc { 1 }
      option :times_per_day_max, Testing::Types::Integer.constrained(included_in: 1..10), default: proc { 5 }
    end

    # @return [<Time>]
    def call
      sampled_dates.flat_map do |date|
        times_for date
      end
    end

    # @return [Range(Date)]
    memoize def date_range
      range_start...range_end
    end

    # @return [Integer]
    memoize def sample_size
      max = date_range.count

      fraction = max * Rational(threshold, 100)

      fraction.to_f.ceil.clamp(1, max)
    end

    # @return [<Date>]
    memoize def sampled_dates
      date_range.to_a.sample(sample_size).sort
    end

    private

    # @param [Date] date
    # @return [<Time>]
    def times_for(date)
      options = {
        from: [date.beginning_of_day, initial_start_time].max,
        to: [date.end_of_day, Time.current].min,
      }

      times_per_day do
        Faker::Time.unique.between(**options)
      end.sort
    end

    def times_per_day(&block)
      rand(times_per_day_min..times_per_day_max).times.map(&block)
    end
  end
end
