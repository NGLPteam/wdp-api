# frozen_string_literal: true

module DSL
  module WithFeedback
    extend ActiveSupport::Concern

    def write(text = "")
      Rails.logger.debug(text)
    end

    def say(message, subitem: false)
      write "#{subitem ? '   ->' : '--'} #{message}"
    end

    def say_with_time(message)
      say(message)
      result = nil
      time = Benchmark.measure { result = yield }
      say "%.4fs" % time.real, :subitem
      say("#{result} rows", :subitem) if result.is_a?(Integer)
      result
    end
  end
end
