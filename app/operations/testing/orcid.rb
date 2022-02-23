# frozen_string_literal: true

module Testing
  module ORCID
    class << self
      # Generate a random ORCID.
      #
      # @return [String]
      def random
        "https://orcid.org/%04d-%04d-%04d-%04d" % 4.times.map { Faker::Number.unique.rand(500...10_000) }
      end
    end
  end
end
